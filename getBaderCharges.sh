#!/bin/bash
#Copyright 2023 - Sufyan M. Shaikh (https://sufyanshk.github.io)

#Get atom names
atomA=`awk 'NR==6{print $1}' CONTCAR`
atomB=`awk 'NR==6{print $2}' CONTCAR`

#Get atom valencies from the POTCAR files
zvalA=`grep ZVAL POTCAR | awk 'NR==1{print $6}'`
zvalB=`grep ZVAL POTCAR | awk 'NR==2{print $6}'`

#Pass the atom names and their valencies to awk
awk -v zvalA=$zvalA -v zvalB=$zvalB -v atomA=$atomA -v atomB=$atomB '{if (NR==1){
	#Declare charges on atoms. These will be used later for storing the total charges on atoms.
	chargeA=0; chargeB=0
	
	#Print the column headings.
	print "# X Y Z Charge MinDist Vol ExtraCharge Element"}

#Go to the first 64 atoms i.e. atom A.
else if ($1>0 && $1<65){

	#Subtract the charge on atom A from its valency.
	$8=zvalA-$5

	#Store the charge on atom A.
	chargeA=chargeA+$8

	#print the line with extra charge present on atom A and write the symbol of atom A in the last column.
	print $0" "atomA}

#Go to the next 64 atoms i.e. atom B.
else if ($1>64 && $1<129){

	#Subtract the charge on atom A from its valency.
	$8=zvalB-$5

	#Store the charge on atom B.
	chargeB=chargeB+$8

	#print the line with extra charge present on atom B and write the symbol of atom B in the last column.
	print $0" "atomB}

#Go to the last 3 lines of the file and print them.
else if (NR>130 && NR<134){
	print $0}
	
#Go to the last line of the file and do the analysis.
else if (NR==134){
	#Print the last line.
	print $0
	
	#If the total charge on atom A is negative, then it is accepting the charge from atom B.
	if (chargeA<0){
	
	#Show the total charge on atoms A and B.
	print "Total charge on "atomA" : "(chargeA)" (Acceptor)"
	print "Total charge on "atomB" : "(chargeB)" (Donor)"
	
	#Show the average charge on atoms A and B.
	print "Avg. charge on "atomA" : "(chargeA/64)" (Acceptor)"
	print "Avg. charge on "atomB" : "(chargeB/64)" (Donor)"}
	
	#If the total charge on atom A is positive, then it is donating the charge to atom B.
	else if (chargeA>0){
	
	#Show the total charge on atoms A and B.
	print "Total charge on "atomA" : "(chargeA)" (Donor)"
	print "Total charge on "atomB" : "(chargeB)" (Acceptor)"
	
	#Show the average charge on atoms A and B.
	print "Avg. charge on "atomA" : "(chargeA/64)" (Donor)"
	print "Avg. charge on "atomB" : "(chargeB/64)" (Acceptor)"}}
}' ACF.dat >> extraCharge"$atomA$atomB".csv

#Show the last 4 lines of the generated file where the extra charge information is stored.
tail -n 4 extraCharge"$atomA$atomB".csv
