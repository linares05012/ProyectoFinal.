#!/bin/bash

ARCHIVO="ventas_compania_actualizado.csv"

# Verificar si el archivo existe
function verificar_archivo {
    if [[ ! -f "$ARCHIVO" ]]; then
        echo " Archivo no encontrado: $ARCHIVO"
        exit 1
    fi
}

verificar_archivo

# Función: Total de ingresos por categoría
function ingresos_por_categoria {
    echo -e "\n Total de ingresos por categoría:"
    tail -n +2 "$ARCHIVO" | awk -F';' '{ ingresos[$4] += $7 } END { for (cat in ingresos) printf "• %s: $%.2f\n", cat, ingresos[cat] }'
}

# Función: Total de ingresos por mes
function ingresos_por_mes {
    echo -e "\n Total de ingresos por mes:"
    tail -n +2 "$ARCHIVO" | awk -F';' '{
        split($1, fecha, "-");
        mes = fecha[1] "-" fecha[2];
        ingresos[mes] += $7
    } END {
        for (m in ingresos) printf "• %s: $%.2f\n", m, ingresos[m]
    }'
}

# Función: Total de ingresos por cliente
function ingresos_por_cliente {
    echo -e "\n Total de ingresos por cliente:"
    tail -n +2 "$ARCHIVO" | awk -F';' '{ ingresos[$2] += $7 } END { for (c in ingresos) printf "• %s: $%.2f\n", c, ingresos[c] }'
}

# Función: Total de ingresos por departamento
function ingresos_por_departamento {
    echo -e "\n Total de ingresos por departamento:"
    tail -n +2 "$ARCHIVO" | awk -F';' '{ ingresos[$3] += $7 } END { for (d in ingresos) printf "• %s: $%.2f\n", d, ingresos[d] }'
}

# Función: Top 10 productos más vendidos
function top_10_productos {
    echo -e "\n Top 10 productos más vendidos (por cantidad):"
    tail -n +2 "$ARCHIVO" | awk -F';' '{
        gsub(/^ +| +$/, "", $5);
        productos[$5] += $6
    } END {
        for (p in productos) print productos[p], p
    }' | sort -rn | head -10 | awk '{ printf "• %s unidades - %s\n", $1, $2 }'
}

# Función: Mostrar menú
function mostrar_menu {
    echo -e "\n========== MENÚ DE REPORTES =========="
    echo "1) Total de ingresos por categoría"
    echo "2) Total de ingresos por mes"
    echo "3) Total de ingresos por cliente"
    echo "4) Total de ingresos por departamento"
    echo "5) Top 10 productos más vendidos"
    echo "0) Salir"
    echo "======================================"
    echo -n "Selecciona una opción: "
}

# Loop del menú
while true; do
    mostrar_menu
    read opcion
    case $opcion in
        1) ingresos_por_categoria ;;
        2) ingresos_por_mes ;;
        3) ingresos_por_cliente ;;
        4) ingresos_por_departamento ;;
        5) top_10_productos ;;
        0) echo "👋 ¡Hasta luego!"; exit 0 ;;
        *) echo " Opción inválida. Intenta de nuevo." ;;
    esac
done
