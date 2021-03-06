#!/bin/bash

# ======================================
# reposado-add-new-products.sh
#
# Script to add new products to a branch
# ======================================

REPOUTIL="/var/git/reposado/code/repoutil"

function usage () {
	echo "Usage: $0 <branch1> <branch2> ..."
	exit
}

# We need a branch.
if [ -z $1 ]; then
	echo "Missing branch"
	usage
	exit 1
fi

# Print the products to be added
echo "Getting a list of new products..."
IFS="
"
NEW_PRODUCTS=( $("${REPOUTIL}" --products | grep -e " \[\] \$") )
if [[ ${#NEW_PRODUCTS[@]} -eq 0 ]]; then
	echo "No new products"
	exit 0
fi
for (( i=0; i<${#NEW_PRODUCTS[@]}; i++ )); do
	echo ${NEW_PRODUCTS[$i]}
done
unset IFS
echo ""

# Ask for confirmation
while true; do
	if [ $# -gt 1 ]; then
		read -p "Add products to catalog $1? [y]n: " yn
	else
		read -p "Add products to catalogs: $*? [y]n: " yn
	fi
    case $yn in
        [Yy]* ) 
	    NEW_PRODUCT_IDS=( $("${REPOUTIL}" --products | grep -e " \[\] \$" | awk '{print $1}') )
	    while [ "$1" != "" ]; do
			echo "$REPOUTIL --add-products ${NEW_PRODUCT_IDS[@]} $1"
			#"${REPOUTIL}" --add-products ${NEW_PRODUCT_IDS[@]} $1
			echo ""
			shift
	    done
	    break;;
        [Nn]* )
	    exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
