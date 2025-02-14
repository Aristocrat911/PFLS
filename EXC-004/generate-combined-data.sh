mkdir -p COMBINED-DATA

for Data in RAW-DATA/DNA*; do
    culture_name=$(basename "$Data")
    nc_name=$(grep "$culture_name" RAW-DATA/sample-translation.txt | awk '{print $2}')

    MAG_counter=1
    BIN_counter=1


    cp "$Data/checkm.txt" "COMBINED-DATA/${nc_name}-CHECKM.txt"
    cp "$Data/gtdb.gtdbtk.tax" "COMBINED-DATA/${nc_name}-GTDB-TAX.txt"

    for fasta_file in "$Data/bins/"*.fasta; do
        bin_name=$(basename "$fasta_file" .fasta)
        completed_genes=$(grep "^${bin_name} " "$Data/checkm.txt" | awk '{print $13}')
        contaminated_genes=$(grep "^${bin_name} " "$Data/checkm.txt" | awk '{print $14}')

        if [[ "$bin_name" == "bin-unbinned" ]]; then
            new_name="${nc_name}_UNBINNED.fa"
            echo "Processing $nc_name unbinned contigs"
        elif (( completed_genes >= 50 && contaminated_genes < 5 )); then
            new_name=$(printf "${nc_name}_MAG_%03d.fa" $MAG_counter)
            echo "Processing $nc_name MAG $bin_name"
            MAG_counter=$((MAG_counter + 1))
        else
            new_name=$(printf "${nc_name}_BIN_%03d.fa" $BIN_counter)
            echo "Processing $nc_name BIN $bin_name"
            BIN_counter=$((BIN_counter + 1))
 fi

        sed "s/^${bin_name}\b/$(basename "$new_name" .fa)/g" "COMBINED-DATA/${nc_name}-CHECKM.txt" > "COMBINED-DATA/${nc_name}-CHECKM-temp.txt" && mv "COMBINED-DATA/${nc_name}-CHECKM-temp.txt" "COMBINED-DATA/${nc_name}-CHECKM.txt"
        sed "s/^${bin_name}\b/$(basename "$new_name" .fa)/g" "COMBINED-DATA/${nc_name}-GTDB-TAX.txt" > "COMBINED-DATA/${nc_name}-GTDB-TAX-temp.txt" && mv "COMBINED-DATA/${nc_name}-GTDB-TAX-temp.txt" "COMBINED-DATA/${nc_name}-GTDB-TAX.txt"

        awk '/^>/ {print ">" $1; next} {print}' "$fasta_file" > "COMBINED-DATA/$new_name"
    done
done
