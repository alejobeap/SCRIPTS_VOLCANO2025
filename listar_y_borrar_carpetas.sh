#!/bin/bash

# Directorio principal
BASE_DIR="GEOC"
OUTPUT_FILE="borrar_archivos.txt"

# Validar que el directorio existe
if [ ! -d "$BASE_DIR" ]; then
  echo "El directorio $BASE_DIR no existe."
  exit 1
fi

# Crear o limpiar el archivo de salida
> "$OUTPUT_FILE"

# Buscar carpetas que cumplan con los criterios
for folder in "$BASE_DIR"/*; do
  if [ -d "$folder" ]; then
    # Contar elementos dentro de la carpeta
    count=$(find "$folder" -mindepth 1 -maxdepth 1 | wc -l)
    
    # Verificar archivos específicos y carpetas
    has_gmt=$(find "$folder" -type f -name "gmt.history" | wc -l)
    has_geo=$(find "$folder" -type f -name "149A_11428_131313.geo.landmask.tif" | wc -l)
    has_local_geo=$(find "$folder" -type f -name "local_2753_149A.geo.landmask.tif" | wc -l)
    has_hillshade=$(find "$folder" -type f -name "hillshade.nc" | wc -l)
    has_temp_folder=$(find "$folder" -type d -name "temp" | wc -l)
    has_temo_folder=$(find "$folder" -type d -name "temo" | wc -l)

    # Condiciones para borrar
    if [ $count -eq $((has_gmt + has_temo_folder)) ] || \
       [ $count -eq $((has_geo + has_gmt + has_hillshade)) ] || \
       [ $count -eq $((has_geo + has_gmt + has_temp_folder)) ] || \
       [ $count -eq $((has_gmt + has_local_geo + has_temp_folder)) ] || \
       [ $count -eq 0 ]; then
      # Registrar en el archivo de texto
      echo "$folder" >> "$OUTPUT_FILE"

      # Borrar la carpeta
      rm -rf "$folder"
      echo "Carpeta $folder borrada."
    fi
  fi
done

echo "El listado de carpetas borradas se ha guardado en $OUTPUT_FILE."
