#!/usr/bin/env bash
set -uo pipefail

ROOT="${1:-$HOME/Procesador_Monociclo_RISCV}"
COMP="$ROOT/componentes"
OUT="$ROOT/simulaciones"
MODULES=(PC MuxPC IM RU IU ALU BU)

if ! command -v ghdl >/dev/null 2>&1; then
    echo "ERROR: GHDL no está instalado." >&2
    exit 1
fi

mkdir -p "$OUT/vcd" "$OUT/logs" "$OUT/build"

usage() {
    echo "Uso: $0 [ruta_proyecto] [--wave MODULO | --all]"
    echo "Sin opciones: compila y simula los siete módulos."
    echo "--wave MODULO: abre el VCD existente en GTKWave."
}

if [[ "${2:-}" == "--wave" ]]; then
    module="${3:-}"
    if [[ ! " ${MODULES[*]} " == *" $module "* ]]; then
        echo "ERROR: módulo no reconocido: $module" >&2
        exit 1
    fi
    if ! command -v gtkwave >/dev/null 2>&1; then
        echo "ERROR: GTKWave no está instalado." >&2
        exit 1
    fi
    vcd="$OUT/vcd/${module}_tb.vcd"
    if [[ ! -f "$vcd" ]]; then
        echo "ERROR: no existe $vcd. Ejecuta primero las simulaciones." >&2
        exit 1
    fi
    exec gtkwave "$vcd"
fi

if [[ "${2:-}" == "--help" || "${2:-}" == "-h" ]]; then
    usage
    exit 0
fi

passed=0
failed=0
skipped=0
for module in "${MODULES[@]}"; do
    dir="$COMP/$module"
    design="$dir/${module}.vhd"
    tb="$dir/${module}_tb.vhd"
    top="${module}_tb"
    build="$OUT/build/$module"
    log="$OUT/logs/${module}.log"
    vcd="$OUT/vcd/${module}_tb.vcd"
    echo
    echo "========== $module =========="
    if [[ ! -f "$design" || ! -f "$tb" ]]; then
        echo "OMITIDO: falta $design o $tb"
        ((skipped+=1))
        continue
    fi
    mkdir -p "$build"
    # El directorio de trabajo independiente evita colisiones entre entidades.
    # Se ejecuta desde la carpeta del módulo para localizar archivos relativos
    # (por ejemplo, instructions.txt de la memoria de instrucciones).
    if (
        cd "$dir" || exit 1
        ghdl -a --std=08 --workdir="$build" "$design" "$tb" &&
        ghdl -e --std=08 --workdir="$build" "$top" &&
        ghdl -r --std=08 --workdir="$build" "$top" --assert-level=error --vcd="$vcd"
    ) >"$log" 2>&1; then
        echo "OK: simulación completada"
        echo "  Registro: $log"
        echo "  Ondas:    $vcd"
        ((passed+=1))
    else
        echo "ERROR: compilación o simulación fallida"
        echo "  Registro: $log"
        tail -n 12 "$log"
        ((failed+=1))
    fi
done

echo
echo "RESUMEN: $passed correctos, $failed fallidos, $skipped omitidos."
echo "Los testbenches deben incluir aserciones para detectar resultados incorrectos."
if (( failed > 0 )); then
    exit 1
fi
if (( skipped > 0 )); then
    exit 2
fi
