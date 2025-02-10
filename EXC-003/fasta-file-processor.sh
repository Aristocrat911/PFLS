echo "FASTA File Statistics:"
echo "----------------------"
for fasta in genes.fa;do

#Count sequences
num_sequences=$(grep'>' "$fasta" | wc -l)

echo "Number of sequences:$num_sequences"

#Total Length Calculation
Total_length=$(awk 'BEGIN{FS=":"} />/{print $(NF), $0}' genes.fa | awk '{print $2}' | sed 's/>//g' | awk '{ total_length += $1; count++ } END { print total_length}')

echo "Total length of sequences:$Total_length"

#The longest and the shortest sequence lengths calculation
Longest_sequence=$(awk 'BEGIN{FS=":"} />/{print $(NF), $0}' genes.fa | sort -n | tail -n 1 | awk '{print $2}' | sed 's/>//g')

echo "Length of the longest sequence:$Longest_sequence"

Shortest_sequence=$(awk 'BEGIN{FS=":"} />/{print $(NF), $0}' genes.fa | sort -n | head -n 1 | awk '{print $2}' | sed 's/>//g')

echo "Length of the shortest sequence:$Shortest_sequence"

#Average sequence length calculation 
Avg_length=$(awk 'BEGIN{FS=":"} />/{print $(NF), $0}' genes.fa | awk '{print $2}' | sed 's/>//g' | awk '{total_length += $1;
count++} END { print total_length/count}')

echo "Average sequence length: $avg_length"

#CG content percentage calculation 

gc_content$(awk '/>/ {if (seq) print seq; print; seq=""; next} {seq=seq $0} END {print seq}' genes.fa > genes-one-line.fa)
$(echo "$sequence" | awk '{gc_count += gsub(/[GgCc]/, ""); total_length += length($0)} END {if (total_length > 0) print 100*(gc_count / total_length)}')

echo "GC Content (%): $gc_content"



done
