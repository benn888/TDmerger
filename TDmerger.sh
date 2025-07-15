#!/bin/bash

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║   _______ _____                                           ║"
echo "║  |__   __|  __ \                                          ║"
echo "║     | |  | |  | |_ __ ___   ___ _ __ __ _  ___ _ __       ║"
echo "║     | |  | |  | | '_ \` _ \ / _ \ '__/ _\` |/ _ \ '__|      ║"
echo "║     | |  | |__| | | | | | |  __/ | | (_| |  __/ |         ║"
echo "║     |_|  |_____/|_| |_| |_|\___|_|  \__, |\___|_|         ║"
echo "║                                      __/ |                ║"
echo "║                                     |___/                 ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"



# Help

Help()
{
   # Display Help
   echo -ne "\nYou are running the \033[1mTDmerger\033[0m script, which merges taxonomic data obtained from different PCR targets into a final consensus taxonomy table\n"
   echo -ne "or barplot. Several parameters are available to filter out unassigned reads, low-abundance taxa, and sparsely detected taxa (see below for details).\n"
   echo -ne "The script also supports the direct generation of QIIME2 visualization files.\n"
   echo
   echo -ne "\e[4mScript workflow\e[0m:\n"
   echo -ne "During the execution of the script, one directory will be created for every sample reported in the ASV tables provided.\n"
   echo -ne "\033[1m• Inside these directories\033[0m, four types of files will be generated, corresponding to the four main parts of the script:\n\n"
   echo -ne "1. Grouping reads into assigned and unassigned categories, and keeping or discarding unassigned reads (controlled by the '--remove-unassigned' argument).\n"
   echo -ne "   \033[1;38;5;111m>\033[0m Generation of [Global_table/taxa_barplot]_assigned_vs_unassigned_{SAMPLENAME}.[tsv/qzv].\n"
   echo -ne "2. Keeping or discarding low-abundance taxa, i.e. taxa with an abundance percentage below a user-defined threshold (controlled by\n"
   echo -ne "the '--min-abundance-threshold' argument).\n"
   echo -ne "   \033[1;38;5;111m>\033[0m Generation of [Global_table/taxa_barplot]_[with/without]_low_abundance_taxa_{SAMPLENAME}.[tsv/qzv].\n"
   echo -ne "3. Keeping or discarding sparsely detected taxa, i.e. taxa identified by no more than X PCR targets ('X' being controlled by the '--min-target-threshold'\n"
   echo -ne "argument).\n"
   echo -ne "   \033[1;38;5;111m>\033[0m Generation of [Global_table/taxa_barplot]_[with/without]_low_abundance_taxa_[with/without]_sparsely_detected_taxa_{SAMPLENAME}.[tsv/qzv].\n"
   echo -ne "4. Generating for each sample a consensus taxonomy table/barplot by merging taxonomic data provided by each PCR target.\n"
   echo -ne "   \033[1;38;5;111m>\033[0m Generation of Consensus_table_{SAMPLENAME}.tsv.\n"
   echo
   echo -ne "\033[1m• Outside these directories\033[0m, a final table/barplot is generated at the end of the analysis by grouping consensus taxonomies for each sample\n"
   echo -ne "into a single file.\n"
   echo -ne "   \033[1;38;5;111m>\033[0m Generation of [Global_table/taxa_barplot]_consensus_final.[tsv/qzv].\n"
   echo
   echo -ne "\e[4mSyntax\e[0m: TDmerger [--table-path|--taxonomy-path|--qiime2|--remove-unassigned|--min-abundance-threshold|--min-target-threshold|--version|--help]\n"
   echo
   echo -ne "\e[4mOptions\e[0m:\n"
   echo -ne "\t--table-path\t\t\tPath to the ASV table files. They must be in either qza or tsv format (not a mix of both).\n" #
   echo -ne "\t\t\t\t\tThere must be one table for each PCR target used. Tables must be named as follows: PCRTARGET_table.qza/tsv.\n"
   echo -ne "\t\t\t\t\tEach table can contain ASV counts for any number of samples (including only one sample). The first column\n"
   echo -ne "\t\t\t\t\tmust contain ASV IDs, and ASV counts for each sample must be reported in the subsequent columns.\n"
   echo -ne "\t\t\t\t\tPlease refer to the structure of QIIME2 feature tables for more details.\n\n"
   echo -ne "\t--taxonomy-path\t\t\tPath to the taxonomy files. They must be in either qza or tsv format (not a mix of both).\n" #
   echo -ne "\t\t\t\t\tThere must be one taxonomy file for each PCR target used. Taxonomy files must be named as follows:\n"
   echo -ne "\t\t\t\t\tPCRTARGET_taxonomy.qza/tsv. The first column must contain ASV IDs, and the 7-level taxonomy must be\n"
   echo -ne "\t\t\t\t\treported in the second column. Please refer to the structure of QIIME2 taxonomy files for more details.\n\n"
   echo -ne "\t--qiime2\t\t\tIndicate whether QIIME2 visualization files (qzv) should be produced in addition to tsv tables.\n" #
   echo -ne "\t\t\t\t\t[Options: 'yes' or 'no']\n\n"
   echo -ne "\t--remove-unassigned\t\tIndicate whether unassigned reads should be discarded during sequence processing by TDmerger.\n" #
   echo -ne "\t\t\t\t\t[Options: 'yes' or 'no']\n\n"
   echo -ne "\t--min-abundance-threshold\tProportion threshold below which low-abundance taxa should be removed. Taxa proportions\n" #
   echo -ne "\t\t\t\t\tare evaluated sample by sample. For example, if '1' is provided, taxa will be removed from samples where\n"
   echo -ne "\t\t\t\t\tthey are observed at a proportion of less than 1%. If '0' is provided, no filtering will be applied and \n"
   echo -ne "\t\t\t\t\tall taxa will be retained. [Option: Integer]\n\n"
   echo -ne "\t--min-target-threshold\t\tNumber of samples considered insufficient to determine whether a particular taxon is\n" #
   echo -ne "\t\t\t\t\tsignificantly represented in the dataset. For example, if '2' is provided, taxa represented in maximum\n"
   echo -ne "\t\t\t\t\ttwo metabarcoding targets will be discarded from the analysis. If '0' is provided, no filtering will be\n"
   echo -ne "\t\t\t\t\tapplied, and all taxa will be retained. [Option: Integer]\n\n"
   echo -ne "\t--version\t\t\tPrint the version of the script.\n\n"
   echo -ne "\t--help\t\t\t\tPrint this help.\n"
   echo

   ## Usage example
   echo -ne "\e[4mUsage example\e[0m:\n\n"
   echo "TDmerger \\"
   echo "  --table-path Tables \\"
   echo "  --taxonomy-path Taxonomies \\"
   echo "  --qiime2 yes \\"
   echo "  --remove-unassigned yes \\"
   echo "  --min-abundance-threshold 0 \\"
   echo "  --min-target-threshold 0"
   echo
}


Version()
{
    echo -ne "TDmerger, version 1.0.0\n\n"
}


# Transform long options to short ones

for arg in "$@"; do
   shift
   case "$arg" in
      '--help')                        set -- "$@" '-h'   ;;
      '--version')                     set -- "$@" '-v'   ;;
      '--table-path')                  set -- "$@" '-a'   ;;
      '--taxonomy-path')               set -- "$@" '-b'   ;;
      '--qiime2')                      set -- "$@" '-c'   ;;
      '--remove-unassigned')           set -- "$@" '-d'   ;;
      '--min-abundance-threshold')     set -- "$@" '-e'   ;;
      '--min-target-threshold')        set -- "$@" '-f'   ;;
      *)                               set -- "$@" "$arg" ;;
   esac
done


# Parse short options

while getopts :hva:b:c:d:e:f: flag
do
   case "${flag}" in
      h) Help
      exit;;
      v) Version
      exit;;
      a) input_tables=${OPTARG};;
      b) input_taxonomies=${OPTARG};;
      c) qiime2=${OPTARG};;
      d) remove_unassigned=${OPTARG};;
      e) min_abundance_threshold=${OPTARG};;
      f) min_target_threshold=${OPTARG};;
      \?) # Invalid option
         echo -ne "Error: Invalid option\n"
         echo -ne "Please consult the help menu with 'TDmerger --help'\n"
         exit;;
   esac
done


# Mandatory arguments

if [ ! "$input_tables" ] || [ ! "$input_taxonomies" ] || [ ! "$qiime2" ] || [ ! "$remove_unassigned" ] || [ ! "$min_abundance_threshold" ] || [ ! "$min_target_threshold" ]
then
   echo -ne "\n\033[31m\033[1mError: arguments --table-path, --taxonomy-path, --qiime2, --remove-unassigned, --min-abundance-threshold, --min-target-threshold must be provided\033[0m\n\n"
   echo -ne "Please consult the help menu with 'TDmerger --help'\n"
   exit;
fi


########################################
# Checking structure of provided files #
########################################

# Checking file structure in the table repository
for file in "${input_tables}"/*
do
   if [[ -f "$file" ]]
   then
      # Extracting only file name
      filename=$(basename "$file")
      # Checking file name structure
      if [[ ! "$filename" =~ ^[A-Za-z0-9_-]+_table\.(qza|tsv)$ ]]
      then
         echo "Error: Invalid file detected: $file. All files must match the required format (e.g., target1_table.qza, target2_table.tsv)." >&2
         exit 1
      fi
   fi
done

# Checking file structure in the taxonomy repository
for file in "${input_taxonomies}"/*
do
   if [[ -f "$file" ]]
   then
      # Extracting only file name
      filename=$(basename "$file")
      # Checking file name structure
      if [[ ! "$filename" =~ ^[A-Za-z0-9_-]+_taxonomy\.(qza|tsv)$ ]]
      then
         echo "Error: Invalid file detected: $file. All files must match the required format (e.g., target1_taxonomy.qza, target2_taxonomy.tsv)." >&2
         exit 1
      fi
   fi
done


###############################################################################
# Checking if provided files are qza and, if they are, converting them to tsv #
###############################################################################

# Tables
########

# Iterating through all files in the directory
qza_files_detected=0
non_qza_files_detected=0

for file in "${input_tables}"/*
do
   if [[ -f "$file" ]]
   then
      # Extracting only file name
      filename=$(basename "$file")
      # Checking if it is a .qza file
      if [[ "$filename" =~ \.qza$ ]]
      then
         qza_files_detected=1
      else
         non_qza_files_detected=1
      fi
   fi
done

# If non .qza files are detected in addition to .qza files, print an error message and exit
if [ "$qza_files_detected" -eq 1 ] && [ "$non_qza_files_detected" -eq 1 ]
then
   echo "Error: The directory contains files that are not only .qza or only .tsv." >&2
   exit 1
elif [ "$qza_files_detected" -eq 1 ] && [ "$non_qza_files_detected" -eq 0 ] # If all files are .qza
then
   # Exporting data to tsv format
   echo -ne "\033[1;38;5;228m[$(date +'%Y-%m-%d || %H:%M:%S')]\033[0m : Converting qza table files to tsv...\n"
   for i in $(ls ${input_tables} | grep "table" | cut -d "." -f 1)
   do
      qiime tools export \
         --input-path ${input_tables}/$i\.qza \
         --output-path .
      biom convert \
         -i feature-table.biom \
         -o feature-table.tsv \
         --to-tsv
      rm feature-table.biom
      awk 'BEGIN {FS=OFS="\t"} NR>1' feature-table.tsv > ${input_tables}/${i}.tsv
      rm feature-table.tsv
   done
fi

# Taxonomies
############

# Iterating through all files in the directory
qza_files_detected=0
non_qza_files_detected=0

for file in "${input_taxonomies}"/*
do
   if [[ -f "$file" ]]
   then
      # Extracting only file name
      filename=$(basename "$file")
      # Checking if it is a .qza file
      if [[ "$filename" =~ \.qza$ ]]
      then
         qza_files_detected=1
      else
         non_qza_files_detected=1
      fi
   fi
done

# If non .qza files are detected in addition to .qza files, print an error message and exit
if [ "$qza_files_detected" -eq 1 ] && [ "$non_qza_files_detected" -eq 1 ]
then
   echo "Error: The directory contains files that are not only .qza or only .tsv." >&2
   exit 1
elif [ "$qza_files_detected" -eq 1 ] && [ "$non_qza_files_detected" -eq 0 ] # If all files are .qza
then
   # Exporting data to tsv format
   echo -ne "\033[1;38;5;228m[$(date +'%Y-%m-%d || %H:%M:%S')]\033[0m : Converting qza taxonomy files to tsv...\n"
   for i in $(ls ${input_taxonomies} | grep "taxonomy" | cut -d "." -f 1)
   do
      qiime tools export \
         --input-path ${input_taxonomies}/$i\.qza \
         --output-path .
      awk 'BEGIN {FS=OFS="\t"} NR>1 {print $1,$2}' taxonomy.tsv > ${input_taxonomies}/${i}.tsv
      rm taxonomy.tsv
   done
fi


###########################
# Initial data processing #
###########################

echo -ne "\033[1;38;5;228m[$(date +'%Y-%m-%d || %H:%M:%S')]\033[0m : Initial data processing...\n"

# Creating sub-tables for every sample and sorting them in sample-specific folders

for i in $(ls ${input_tables} | grep "table.tsv" | cut -d "." -f 1)
do
   awk -vTARG="$i" 'BEGIN {FS="\t"; getline; split($0,header,"\t")} {for (i=2; i<=NF; i++) {print $1"\t"$i > TARG".tsv_"header[i]}}' ${input_tables}/$i.tsv
done

for i in $(ls | grep "table.tsv_" | awk -F "tsv_" '{print $2}' | cut -d '_' -f 2 | sort | uniq)
do
   mkdir $i
   mv *tsv_*$i $i
done


# Creating a variable containing the name of every sample folder

sample_directories=$(ls */ | grep "table.tsv_" | awk -F "tsv_" '{print $2}' | cut -d '_' -f 2 | sort | uniq)


# Renaming table file names

for directory in $sample_directories
do
   for i in $(ls $directory | awk -F ".tsv" '{print $1}')
   do
      mv $directory/$i* $directory/$i\.tsv
   done
done


# Creating a linking table for each target in each sample directory

for directory in $sample_directories
do
   for i in $(ls ${input_taxonomies} | grep "taxonomy.tsv" | awk -F "_taxonomy" 'BEGIN {OFS="\t"} {print $1}' | sort | uniq)
   do
      join -t $'\t' -1 1 -2 1 -a 1 \
            <(sort -t $'\t' -k 1b,1 $directory/$i\_table.tsv) \
            <(sort -t $'\t' -k 1b,1 ${input_taxonomies}/$i\_taxonomy.tsv) > $directory/$i\_linking_table
   done
done

for directory in $sample_directories
do
   rm $directory/*table.tsv
done


# Merging ASV abundances for identical taxa and adding a header line

for directory in $sample_directories
do
   for i in $(ls $directory | grep "linking_table" | awk -F "_linking_table" '{print $1}' | sort | uniq)
   do
      awk 'BEGIN {FS=OFS="\t"; print "index", "'$i'"} {a[$3] += $2} END {for (j in a) print j, a[j]}' $directory/${i}_linking_table > $directory/${i}_taxa_abundances
   done
   rm $directory/*linking_table
done


################################################################################################
# Creating a first global table to highlight the proportion of unassigned reads in each sample #
################################################################################################

echo -ne "\033[1;38;5;228m[$(date +'%Y-%m-%d || %H:%M:%S')]\033[0m : Comparing abundances of assigned vs. unassigned reads...\n"

# Creating working files

for directory in $sample_directories
do
   for i in $(ls $directory | grep "taxa_abundances")
   do
      cp $directory/$i $directory/$i\_with_unassigned
   done
done


# Replacing every taxa other than unassigned by 'Assigned', merging ASV abundances for 'Assigned' lines and adding an "Unassigned" line in files not displaying it

for directory in $sample_directories
do
   for i in $(ls $directory | grep "_with_unassigned")
   do
      awk 'BEGIN {FS=OFS="\t"} 
           NR == 1 {print; next} 
           $1 !~ /Unassigned|index/ {$1 = "Assigned"} 
           {a[$1] += $2} 
           END {
               for (taxa in a) print taxa, a[taxa];
               if (!("Unassigned" in a)) print "Unassigned", 0
           }' $directory/$i > $directory/${i}_tmp
      mv $directory/${i}_tmp $directory/$i
   done
done


# Creating a global file

for directory in $sample_directories
do
   # Creating and sorting the global table
   echo -ne "index\nUnassigned\nAssigned\n" | sort -k1,1 > $directory/Global_table_with_unassigned

   for i in $(ls $directory | grep "taxa_abundances_with_unassigned")
   do
      # Sort the input file by the first column (taxa names)
      sort -k1,1 $directory/$i -o $directory/${i}_sorted

      # Merging the global table with each sorted input file
      join \
         -t $'\t' \
         -a 1 \
         -e "0" \
         -o auto $directory/Global_table_with_unassigned $directory/${i}_sorted > $directory/Global_table_with_unassigned_tmp
      mv $directory/Global_table_with_unassigned_tmp $directory/Global_table_with_unassigned
      rm $directory/${i}_sorted
   done

   rm $directory/*taxa_abundances_with_unassigned

   # Re-ordering every global table
   echo -ne "$(grep -w "index" $directory/Global_table_with_unassigned)\n$(grep -w -v "index" $directory/Global_table_with_unassigned)\n" > $directory/Global_table_assigned_vs_unassigned_${directory}.tsv
   rm $directory/Global_table_with_unassigned
done


if [ $qiime2 = "yes" ]
then
   # Creating taxa barplot qzv files
   ## Creating a feature table qza file

   for directory in $sample_directories
   do
      biom convert \
         -i $directory/Global_table_assigned_vs_unassigned_${directory}.tsv \
         -o $directory/Global_table_assigned_vs_unassigned_${directory}.biom \
         --table-type "OTU table" \
         --to-hdf5

      qiime tools import \
         --input-path $directory/Global_table_assigned_vs_unassigned_${directory}.biom \
         --type 'FeatureTable[Frequency]' \
         --input-format BIOMV210Format \
         --output-path $directory/Global_table_assigned_vs_unassigned_${directory}.qza

      echo -ne "sample-id\tSampleName\n#q2:types\tcategorical\n$(paste <(head -n 1 $directory/Global_table_assigned_vs_unassigned_${directory}.tsv | sed "s/\t/\n/g" | awk 'NR>1') <(head -n 1 $directory/Global_table_assigned_vs_unassigned_${directory}.tsv | sed "s/\t/\n/g" | awk 'NR>1'))\n" > $directory/sample_metadata_assigned_vs_unassigned_${directory}.tsv
   done


   ## Creating a taxonomy qza file

   for directory in $sample_directories
   do
      paste \
         <(awk 'BEGIN {FS=OFS="\t"} NR>1 {print $1}' $directory/Global_table_assigned_vs_unassigned_${directory}.tsv) \
         <(awk 'BEGIN {FS=OFS="\t"} NR>1 {print $1}' $directory/Global_table_assigned_vs_unassigned_${directory}.tsv | \
            sed "s/Assigned/k__Assigned; p__Assigned; c__Assigned; o__Assigned; f__Assigned; g__Assigned; s__Assigned/g" | \
            sed "s/Unassigned/k__Unassigned; p__Unassigned; c__Unassigned; o__Unassigned; f__Unassigned; g__Unassigned; s__Unassigned/g") > $directory/taxonomy_assigned_vs_unassigned_${directory}.tsv

      qiime tools import \
         --type 'FeatureData[Taxonomy]' \
         --input-format HeaderlessTSVTaxonomyFormat \
         --input-path $directory/taxonomy_assigned_vs_unassigned_${directory}.tsv \
         --output-path $directory/taxonomy_assigned_vs_unassigned_${directory}.qza
   done

   ## Generating the taxa barplot

   for directory in $sample_directories
   do
      qiime taxa barplot \
         --i-table $directory/Global_table_assigned_vs_unassigned_${directory}.qza \
         --i-taxonomy $directory/taxonomy_assigned_vs_unassigned_${directory}.qza \
         --m-metadata-file $directory/sample_metadata_assigned_vs_unassigned_${directory}.tsv \
         --o-visualization $directory/taxa_barplot_assigned_vs_unassigned_${directory}.qzv

      rm $directory/Global_table_assigned_vs_unassigned_${directory}.*
      rm $directory/sample_metadata_assigned_vs_unassigned_${directory}.tsv
      rm $directory/taxonomy_assigned_vs_unassigned_${directory}.*
   done
fi


##################################################
# Removing unassigned from each file if required #
##################################################

if [ $remove_unassigned = "yes" ]
then
   echo -ne "\033[1;38;5;228m[$(date +'%Y-%m-%d || %H:%M:%S')]\033[0m : Removing unassigned reads...\n"
   for directory in $sample_directories
   do
      for i in $(ls $directory | grep "taxa_abundances")
      do
         awk -F '\t' '$1!="Unassigned"' $directory/$i > $directory/${i}_tmp
         mv $directory/${i}_tmp $directory/$i
      done
   done
fi

###########################################
# Removing low-abundance taxa if required #
###########################################

if awk "BEGIN {exit !($min_abundance_threshold != 0)}"
then
   echo -ne "\033[1;38;5;228m[$(date +'%Y-%m-%d || %H:%M:%S')]\033[0m : Removing low-abundance taxa...\n"
   # Removing low-abundance taxa from each file
   for directory in $sample_directories
   do
      for i in $(ls $directory | grep "taxa_abundances")
      do
         sum=$(awk 'BEGIN {FS="\t"} ; {sum+=$2} END {print sum}' $directory/$i)
         div=$(LC_NUMERIC=C printf '%.0f\n' $(awk -vSUM="$sum" -vMATHRESH="$min_abundance_threshold" 'BEGIN {print SUM/(100/MATHRESH)}'))
         awk -F '\t' -vDIV="$div" 'NR==1 || $2>=DIV' $directory/$i > $directory/${i}_tmp
         mv $directory/${i}_tmp $directory/$i
      done
   done

   # Gathering taxa abundances for all targets into one global file
   for directory in $sample_directories
   do
      # Creating a list of unique taxonomic lineages found in all files
      cat $directory/*_taxa_abundances | awk -F '\t' '{print $1}' | sort | uniq > $directory/Global_table
      
      # Adding lines with taxa from global table that are missing in each taxa abundance file
      for i in $(ls $directory | grep "taxa_abundances")
      do
         echo -ne "$(cat $directory/$i)\n$(cat <(cut -d $'\t' -f 1 $directory/$i) $directory/Global_table | sort | uniq -u)\n" \
            > $directory/${i}_tmp
         mv $directory/${i}_tmp $directory/$i
      done
      
      # Adding "0" where they lack in taxa abundance tables
      for i in $(ls $directory | grep "taxa_abundances")
      do
         awk 'BEGIN {FS=OFS="\t"} $1 && !$2{ $2="0" }1' $directory/$i > $directory/${i}_tmp
         mv $directory/${i}_tmp $directory/$i
         sed -i '/^$/d' $directory/$i
      done

      # Adding data from every taxa abundance table into the global table
      for i in $(ls $directory | grep "taxa_abundances")
      do
         # Sort the input file by the first column (taxa names)
         sort -k1,1 $directory/$i -o $directory/${i}_sorted

         # Merging the global table with each sorted input file
         join \
            -t $'\t' \
            -a 1 \
            -e "0" \
            -o auto $directory/Global_table $directory/${i}_sorted > $directory/Global_table_tmp
         mv $directory/Global_table_tmp $directory/Global_table
         rm $directory/${i}_sorted
      done

      rm $directory/*taxa_abundances

      # Re-ordering every global table
      echo -ne "$(grep -w "index" $directory/Global_table)\n$(grep -w -v "index" $directory/Global_table)\n" > $directory/Global_table_tmp
      mv $directory/Global_table_tmp $directory/Global_table
      
      # Deleting taxa not present in the global table
      awk -F '\t' '{
         all_zero = 1
         for (i = 2; i <= NF; i++) {
            if ($i != "0") {
               all_zero = 0
               break
            }
         }
         if (!all_zero) print
      }' $directory/Global_table > $directory/Global_table_without_low_abundance_taxa_${directory}.tsv
      rm $directory/Global_table
   done

   if [ $qiime2 = "yes" ]
   then
      # Creating taxa barplots qzv files
      ## Creating a feature table qza file
      
      for directory in $sample_directories
      do
         biom convert \
            -i $directory/Global_table_without_low_abundance_taxa_${directory}.tsv \
            -o $directory/Global_table_without_low_abundance_taxa_${directory}.biom \
            --table-type "OTU table" \
            --to-hdf5
         qiime tools import \
            --input-path $directory/Global_table_without_low_abundance_taxa_${directory}.biom \
            --type 'FeatureTable[Frequency]' \
            --input-format BIOMV210Format \
            --output-path $directory/Global_table_without_low_abundance_taxa_${directory}.qza
         echo -ne "sample-id\tSampleName\n#q2:types\tcategorical\n$(paste <(head -n 1 $directory/Global_table_without_low_abundance_taxa_${directory}.tsv | sed "s/\t/\n/g" | awk 'NR>1') <(head -n 1 $directory/Global_table_without_low_abundance_taxa_${directory}.tsv | sed "s/\t/\n/g" | awk 'NR>1'))\n" > $directory/sample_metadata_${directory}.tsv
      done

      ## Creating a taxonomy qza file

      for directory in $sample_directories
      do
         awk 'BEGIN {FS=OFS="\t"} NR>1 {print $1,$1}' $directory/Global_table_without_low_abundance_taxa_${directory}.tsv > $directory/taxonomy_${directory}.tsv
         qiime tools import \
            --type 'FeatureData[Taxonomy]' \
            --input-format HeaderlessTSVTaxonomyFormat \
            --input-path $directory/taxonomy_${directory}.tsv \
            --output-path $directory/taxonomy_${directory}.qza
      done

      ## Generating the taxa barplot

      for directory in $sample_directories
      do
         qiime taxa barplot \
            --i-table $directory/Global_table_without_low_abundance_taxa_${directory}.qza \
            --i-taxonomy $directory/taxonomy_${directory}.qza \
            --m-metadata-file $directory/sample_metadata_${directory}.tsv \
            --o-visualization $directory/taxa_barplot_without_low_abundance_taxa_${directory}.qzv

         rm $directory/Global_table_without_low_abundance_taxa_${directory}.biom
         rm $directory/Global_table_without_low_abundance_taxa_${directory}.qza
         rm $directory/sample_metadata_${directory}.tsv
         rm $directory/taxonomy_${directory}.*
      done
   fi
else
   echo -ne "\033[1;38;5;228m[$(date +'%Y-%m-%d || %H:%M:%S')]\033[0m : Processing data by keeping low-abundance taxa...\n"
   # Gathering taxa abundances for all targets into one global file
   for directory in $sample_directories
   do
      # Creating a list of unique taxonomic lineages found in all files
      cat $directory/*_taxa_abundances | awk -F '\t' '{print $1}' | sort | uniq > $directory/Global_table
   
      # Adding lines with taxa from global table that are missing in each taxa abundance file
      for i in $(ls $directory | grep "taxa_abundances")
      do
         echo -ne "$(cat $directory/$i)\n$(cat <(cut -d $'\t' -f 1 $directory/$i) $directory/Global_table | sort | uniq -u)\n" > $directory/${i}_tmp
         mv $directory/${i}_tmp $directory/$i
      done  
   
      # Adding "0" where they lack in taxa abundance tables
      for i in $(ls $directory | grep "taxa_abundances")
      do
         awk 'BEGIN {FS=OFS="\t"} $1 && !$2{ $2="0" }1' $directory/$i > $directory/${i}_tmp
         mv $directory/${i}_tmp $directory/$i
         sed -i '/^$/d' $directory/$i
      done

      # Adding data from every taxa abundance table into the global table
      for i in $(ls $directory | grep "taxa_abundances")
      do
         # Sort the input file by the first column (taxa names)
         sort -k1,1 $directory/$i -o $directory/${i}_sorted

         # Merging the global table with each sorted input file
         join \
            -t $'\t' \
            -a 1 \
            -e "0" \
            -o auto $directory/Global_table $directory/${i}_sorted > $directory/Global_table_tmp
         mv $directory/Global_table_tmp $directory/Global_table
         rm $directory/${i}_sorted
      done

      rm $directory/*taxa_abundances

      # Re-ordering every global table
      echo -ne "$(grep -w "index" $directory/Global_table)\n$(grep -w -v "index" $directory/Global_table)\n" > $directory/Global_table_tmp
      mv $directory/Global_table_tmp $directory/Global_table
      
      # Deleting taxa not present in the global table
      awk -F '\t' '{
         all_zero = 1
         for (i = 2; i <= NF; i++) {
            if ($i != "0") {
               all_zero = 0
               break
            }
         }
         if (!all_zero) print
      }' $directory/Global_table > $directory/Global_table_with_low_abundance_taxa_${directory}.tsv
      rm $directory/Global_table
   done

   if [ $qiime2 = "yes" ]
   then
      # Creating taxa barplots qzv files
      ## Creating a feature table qza file
      
      for directory in $sample_directories
      do
         biom convert \
            -i $directory/Global_table_with_low_abundance_taxa_${directory}.tsv \
            -o $directory/Global_table_with_low_abundance_taxa_${directory}.biom \
            --table-type "OTU table" \
            --to-hdf5
         qiime tools import \
            --input-path $directory/Global_table_with_low_abundance_taxa_${directory}.biom \
            --type 'FeatureTable[Frequency]' \
            --input-format BIOMV210Format \
            --output-path $directory/Global_table_with_low_abundance_taxa_${directory}.qza
         echo -ne "sample-id\tSampleName\n#q2:types\tcategorical\n$(paste <(head -n 1 $directory/Global_table_with_low_abundance_taxa_${directory}.tsv | sed "s/\t/\n/g" | awk 'NR>1') <(head -n 1 $directory/Global_table_with_low_abundance_taxa_${directory}.tsv | sed "s/\t/\n/g" | awk 'NR>1'))\n" > $directory/sample_metadata_${directory}.tsv
      done

      ## Creating a taxonomy qza file

      for directory in $sample_directories
      do
         awk 'BEGIN {FS=OFS="\t"} NR>1 {print $1,$1}' $directory/Global_table_with_low_abundance_taxa_${directory}.tsv > $directory/taxonomy_${directory}.tsv
         qiime tools import \
            --type 'FeatureData[Taxonomy]' \
            --input-format HeaderlessTSVTaxonomyFormat \
            --input-path $directory/taxonomy_${directory}.tsv \
            --output-path $directory/taxonomy_${directory}.qza
      done

      ## Generating the taxa barplot

      for directory in $sample_directories
      do
         qiime taxa barplot \
            --i-table $directory/Global_table_with_low_abundance_taxa_${directory}.qza \
            --i-taxonomy $directory/taxonomy_${directory}.qza \
            --m-metadata-file $directory/sample_metadata_${directory}.tsv \
            --o-visualization $directory/taxa_barplot_with_low_abundance_taxa_${directory}.qzv

         rm $directory/Global_table_with_low_abundance_taxa_${directory}.biom
         rm $directory/Global_table_with_low_abundance_taxa_${directory}.qza
         rm $directory/sample_metadata_${directory}.tsv
         rm $directory/taxonomy_${directory}.*
      done
   fi
fi

###############################################
# Removing sparsely detected taxa if required #
###############################################

# Recording in a variable whether low-abundance taxa were removed at the previous step
#wowo="$(ls "$(echo "$sample_directories" | awk 'NR==1')" | grep "Global_table" | cut -d "_" -f 3)"

if awk "BEGIN {exit !($min_abundance_threshold > 0)}"
then
   wowo="without"
else
   wowo="with"
fi


if [ "$min_target_threshold" != "0" ]
then
   echo -ne "\033[1;38;5;228m[$(date +'%Y-%m-%d || %H:%M:%S')]\033[0m : Removing sparsely detected taxa...\n"
   # Creating a third table by removing taxa identified by max the number of PCR targets reported by $min_target_threshold
   for directory in $sample_directories
   do
      # Adding a new column with the number of targets that identified each taxon
      awk 'BEGIN {FS=OFS="\t"} NR==1 {print $0"\tTarget_count"; next} {count=0; for (i=2; i<=NF; i++) if ($i != 0) count++; print $0"\t"count}' \
         $directory/Global_table_${wowo}_low_abundance_taxa_${directory}.tsv > $directory/Global_table

      # Removing lines for taxa identified by max the number of PCR targets reported by $min_target_threshold
      awk -vMTTHRESH="$min_target_threshold" 'BEGIN {FS=OFS="\t"} NR==1 || ($NF >= MTTHRESH) {NF--; print}' \
         $directory/Global_table > $directory/Global_table_${wowo}_low_abundance_taxa_without_sparcely_detected_taxa_${directory}.tsv
      rm $directory/Global_table
   done

   if [ $qiime2 = "yes" ]
   then
      # Creating taxa barplot qzv files
      for directory in $sample_directories
      do
         # Creating a feature table qza file
         biom convert \
            -i $directory/Global_table_${wowo}_low_abundance_taxa_without_sparcely_detected_taxa_${directory}.tsv \
            -o $directory/Global_table_${wowo}_low_abundance_taxa_without_sparcely_detected_taxa_${directory}.biom \
            --table-type "OTU table" \
            --to-hdf5
         qiime tools import \
            --input-path $directory/Global_table_${wowo}_low_abundance_taxa_without_sparcely_detected_taxa_${directory}.biom \
            --type 'FeatureTable[Frequency]' \
            --input-format BIOMV210Format \
            --output-path $directory/Global_table_${wowo}_low_abundance_taxa_without_sparcely_detected_taxa_${directory}.qza
                
         # Creating a metadata file
         echo -ne "sample-id\tSampleName\n#q2:types\tcategorical\n$(paste <(head -n 1 $directory/Global_table_${wowo}_low_abundance_taxa_without_sparcely_detected_taxa_${directory}.tsv | sed "s/\t/\n/g" | awk 'NR>1') <(head -n 1 $directory/Global_table_${wowo}_low_abundance_taxa_without_sparcely_detected_taxa_${directory}.tsv | sed "s/\t/\n/g" | awk 'NR>1'))\n" > $directory/sample_metadata_${directory}.tsv
                
         # Creating a taxonomy qza file
         awk 'BEGIN {FS=OFS="\t"} NR>1 {print $1,$1}' $directory/Global_table_${wowo}_low_abundance_taxa_without_sparcely_detected_taxa_${directory}.tsv \
            > $directory/taxonomy_${directory}.tsv
         
         qiime tools import \
            --type 'FeatureData[Taxonomy]' \
            --input-format HeaderlessTSVTaxonomyFormat \
            --input-path $directory/taxonomy_${directory}.tsv \
            --output-path $directory/taxonomy_${directory}.qza
             
         # Generating the taxa barplot   
         qiime taxa barplot \
            --i-table $directory/Global_table_${wowo}_low_abundance_taxa_without_sparcely_detected_taxa_${directory}.qza \
            --i-taxonomy $directory/taxonomy_${directory}.qza \
            --m-metadata-file $directory/sample_metadata_${directory}.tsv \
            --o-visualization $directory/taxa_barplot_${wowo}_low_abundance_taxa_without_sparcely_detected_taxa_${directory}.qzv

         rm $directory/Global_table_${wowo}_low_abundance_taxa_without_sparcely_detected_taxa_${directory}.biom
         rm $directory/Global_table_${wowo}_low_abundance_taxa_without_sparcely_detected_taxa_${directory}.qza
         rm $directory/sample_metadata_${directory}.tsv
         rm $directory/taxonomy_${directory}*
      done
   fi
elif [ "$min_target_threshold" -eq 0 ]
then
   echo -ne "\033[1;38;5;228m[$(date +'%Y-%m-%d || %H:%M:%S')]\033[0m : Processing data by keeping sparsely detected taxa...\n"
   # Renaming files to mention the presence of sparcely detected taxa
   for directory in $sample_directories
   do
      mv $directory/Global_table_${wowo}_low_abundance_taxa_${directory}.tsv $directory/Global_table_${wowo}_low_abundance_taxa_with_sparcely_detected_taxa_${directory}.tsv
   done

   if [ $qiime2 = "yes" ]
   then
      for directory in $sample_directories
      do
         mv $directory/taxa_barplot_${wowo}_low_abundance_taxa_${directory}.qzv $directory/taxa_barplot_${wowo}_low_abundance_taxa_with_sparcely_detected_taxa_${directory}.qzv
      done
   fi
fi

################################
# Generating a consensus graph #
################################

echo -ne "\033[1;38;5;228m[$(date +'%Y-%m-%d || %H:%M:%S')]\033[0m : Generating a consensus taxonomy file...\n"

# Recording in a variable whether sparcely detected taxa were removed at the previous step
#wowo2="$(ls "$(echo "$sample_directories" | awk 'NR==1')" | grep "Global_table" | cut -d "_" -f 7)"

if awk "BEGIN {exit !($min_target_threshold > 0)}"
then
   wowo2="without"
else
   wowo2="with"
fi

# Computing for each sample the taxa consensus abundance by averaging the read counts obtained with each PCR target

for directory in $sample_directories
do
   echo -e "index\t$directory" > $directory/${directory}_consensus_table.tsv
   awk -F '\t' 'NR==1 {next} {
      sum=0;
      for (i=2; i<=NF; i++) {
         sum += $i;
      }
      avg = sum / (NF-1);
      print $1 "\t" avg;
   }' $directory/Global_table_${wowo}_low_abundance_taxa_${wowo2}_sparcely_detected_taxa_${directory}.tsv >> $directory/${directory}_consensus_table.tsv
done

# Creating the final consensus table/barplot gathering the consensus taxonomic composition of all samples
## Creating a list of unique taxonomic lineages found in all files

cat */*_consensus_table.tsv | awk -F '\t' '{print $1}' | sort | uniq > Consensus_table_tmp.tsv

for directory in $sample_directories
do
   ## Adding lines with taxa from global table that are missing in each taxa abundance file
   echo -ne "$(cat $directory/${directory}_consensus_table.tsv)\n$(cat <(cut -d $'\t' -f 1 $directory/${directory}_consensus_table.tsv) Consensus_table_tmp.tsv | sort | uniq -u)\n" \
      > $directory/${directory}_consensus_table.tsv_tmp
   mv $directory/${directory}_consensus_table.tsv_tmp $directory/${directory}_consensus_table.tsv
      
   ## Adding "0" where they lack in taxa abundance tables
   awk 'BEGIN {FS=OFS="\t"} $1 && !$2{ $2="0" }1' $directory/${directory}_consensus_table.tsv > $directory/${directory}_consensus_table.tsv_tmp
   mv $directory/${directory}_consensus_table.tsv_tmp $directory/${directory}_consensus_table.tsv
   sed -i '/^$/d' $directory/${directory}_consensus_table.tsv
done

## Adding data from every sample table into the final consensus table
for directory in $sample_directories
do
   join \
      -t $'\t' \
      -1 1 \
      -2 1 \
      -a 1 \
      -e "0" \
      -o auto \
      <(sort -k1,1 Consensus_table_tmp.tsv) \
      <(sort -k1,1 $directory/${directory}_consensus_table.tsv) > Consensus_table_tmp_merged.tsv
   mv Consensus_table_tmp_merged.tsv Consensus_table_tmp.tsv
done

mv Consensus_table_tmp.tsv Consensus_table.tsv

# Checking the correct line order in the consensus table
echo -ne "$(grep -w "index" Consensus_table.tsv)\n$(grep -w -v "index" Consensus_table.tsv)\n" > Consensus_table.tsv_tmp
mv Consensus_table.tsv_tmp Consensus_table.tsv

if [ $qiime2 = "yes" ]
then
   # Creating taxa barplots qzv files
   ## Creating a feature table qza file
   biom convert \
      -i Consensus_table.tsv \
      -o Consensus_table.biom \
      --table-type "OTU table" \
      --to-hdf5
   qiime tools import \
      --input-path Consensus_table.biom \
      --type 'FeatureTable[Frequency]' \
      --input-format BIOMV210Format \
      --output-path Consensus_table.qza
   echo -ne "sample-id\tSampleName\n#q2:types\tcategorical\n$(paste <(head -n 1 Consensus_table.tsv | sed "s/\t/\n/g" | awk 'NR>1') <(head -n 1 Consensus_table.tsv | sed "s/\t/\n/g" | awk 'NR>1'))\n" > sample_metadata.tsv


   ## Creating a taxonomy qza file
   awk 'BEGIN {FS=OFS="\t"} NR>1 {print $1,$1}' Consensus_table.tsv > taxonomy.tsv
   qiime tools import \
      --type 'FeatureData[Taxonomy]' \
      --input-format HeaderlessTSVTaxonomyFormat \
      --input-path taxonomy.tsv \
      --output-path taxonomy.qza


   ## Generating the taxa barplot
   qiime taxa barplot \
      --i-table Consensus_table.qza \
      --i-taxonomy taxonomy.qza \
      --m-metadata-file sample_metadata.tsv \
      --o-visualization taxa_barplot_consensus.qzv

   rm Consensus_table.biom
   rm Consensus_table.qza
   rm sample_metadata.tsv
   rm taxonomy.*
fi

unset input_tables
unset input_taxonomies
unset qiime2
unset remove_unassigned
unset min_abundance_threshold
unset min_target_threshold
unset wowo
unset wowo2
unset qza_files_detected
unset non_qza_files_detected
unset sample_directories

