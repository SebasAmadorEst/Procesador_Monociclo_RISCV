# Diseño y simulación de un procesador monociclo RISC-V RV32I

Proyecto académico de **Arquitectura de Computadores** de la **Universidad Tecnológica de Pereira (UTP)**, periodo **2026-2**.

## Integrantes

| Integrante | Código estudiantil | Correo institucional |
|---|---|---|
| Juan Sebastián Amador Martínez | 1025060894 | sebastian.amador@utp.edu.co |
| Camilo Giraldo Montoya | 1193094624 | camilo.giraldo1@utp.edu.co |

**Docente:** Martha Ascencio Mendoza.

## Descripción

El proyecto desarrolla y verifica, mediante **VHDL**, componentes de un procesador monociclo basado en la arquitectura **RISC-V RV32I**. La validación individual se realiza con bancos de pruebas (*testbenches*) en **GHDL** y el análisis de señales con **GTKWave**.

> **Estado actual:** siete módulos implementados con sus respectivos testbenches y evidencias de simulación. La memoria de datos (DM), la unidad de control (CU) y la integración del procesador están pendientes. Las pruebas individuales no equivalen todavía a la validación del procesador completo.

## Componentes

| Módulo | Descripción | Estado |
|---|---|---|
| `PC` | Contador de programa | Implementado y probado individualmente |
| `MuxPC` | Multiplexor para seleccionar el siguiente PC | Implementado y probado individualmente |
| `IM` | Memoria de instrucciones | Implementado y probado individualmente |
| `RU` | Unidad de registros | Implementado y probado individualmente |
| `IU` | Unidad de inmediatos | Implementado y probado individualmente |
| `ALU` | Unidad aritmético-lógica | Implementado y probado individualmente |
| `BU` | Unidad de saltos y comparaciones | Implementado y probado individualmente |
| `DM` | Memoria de datos | Pendiente |
| `CU` | Unidad de control | Pendiente |
| `integracion` | Conexión y prueba del procesador monociclo | Pendiente |

## Estructura del repositorio

```text
Procesador_Monociclo_RISCV/
├── README.md
├── .gitignore
├── simular_componentes.sh
├── componentes/
│   ├── PC/            # PC.vhd y PC_tb.vhd
│   ├── MuxPC/         # MuxPC.vhd y MuxPC_tb.vhd
│   ├── IM/            # IM.vhd, IM_tb.vhd e instructions.txt
│   ├── RU/            # RU.vhd y RU_tb.vhd
│   ├── IU/            # IU.vhd y IU_tb.vhd
│   ├── ALU/           # ALU.vhd y ALU_tb.vhd
│   ├── BU/            # BU.vhd y BU_tb.vhd
│   ├── DM/            # Pendiente
│   └── CU/            # Pendiente
├── integracion/       # Pendiente
└── simulaciones/
    ├── capturas/      # Capturas PNG de los siete módulos
    ├── configuraciones/ # Archivos .gtkw
    ├── logs/          # Registros de las pruebas
    ├── vcd/           # Formas de onda .vcd
    └── build/         # Archivos temporales de GHDL (ignorados por Git)
```

> Git no conserva carpetas vacías por sí solas. Por ello, las carpetas pendientes `DM/`, `CU/` e `integracion/` pueden no aparecer en GitHub hasta que contengan archivos versionados.

## Requisitos

- Linux con **Bash**.
- **GHDL** con soporte para VHDL-2008.
- **GTKWave** para visualizar las formas de onda.

En Ubuntu se pueden instalar con:

```bash
sudo apt update
sudo apt install ghdl gtkwave
```

## Compilar y ejecutar las pruebas

Desde la raíz del proyecto:

```bash
chmod +x simular_componentes.sh
./simular_componentes.sh "$PWD"
```

El script compila y ejecuta, en orden, los testbenches de `PC`, `MuxPC`, `IM`, `RU`, `IU`, `ALU` y `BU` con VHDL-2008. Guarda los resultados en:

- `simulaciones/logs/MODULO.log`: registro de compilación y ejecución.
- `simulaciones/vcd/MODULO_tb.vcd`: señales generadas por la simulación.
- `simulaciones/build/MODULO/`: archivos de trabajo temporales de GHDL.

En la validación individual documentada se obtuvo el resumen **7 correctos, 0 fallidos, 0 omitidos**. Para comprobarlo en otra máquina, es necesario ejecutar nuevamente el script.

**Importante:** pasar `"$PWD"` es recomendable porque el script utiliza, por defecto, la ruta `$HOME/Procesador_Monociclo_RISCV`, que puede no coincidir con la ubicación de tu clon.

## Visualizar las formas de onda

Para abrir una simulación individual, por ejemplo la ALU:

```bash
gtkwave simulaciones/vcd/ALU_tb.vcd simulaciones/configuraciones/ALU.gtkw
```

También es posible abrir el VCD mediante el script (sin cargar automáticamente la configuración `.gtkw`):

```bash
./simular_componentes.sh "$PWD" --wave ALU
```

Las capturas ya obtenidas están en `simulaciones/capturas/`:

| PC | MuxPC | IM | RU | IU | ALU | BU |
|---|---|---|---|---|---|---|
| [Ver](simulaciones/capturas/PC.png) | [Ver](simulaciones/capturas/MuxPC.png) | [Ver](simulaciones/capturas/IM.png) | [Ver](simulaciones/capturas/RU.png) | [Ver](simulaciones/capturas/IU.png) | [Ver](simulaciones/capturas/ALU.png) | [Ver](simulaciones/capturas/BU.png) |

## Próximas etapas

1. Implementar y verificar los módulos `DM` y `CU`.
2. Integrar los componentes en el procesador monociclo.
3. Preparar y ejecutar un programa de prueba que cubra las familias de instrucciones requeridas.
4. Documentar las señales y los ciclos de ejecución de la simulación integrada.
5. Actualizar el informe técnico y las evidencias finales.

## Nota académica

Este repositorio contiene una implementación académica en desarrollo. Las capturas, los VCD y los registros corresponden a pruebas de componentes; no deben interpretarse como evidencia de funcionamiento integral del procesador hasta completar la integración.
