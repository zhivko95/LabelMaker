import argparse
import time
import os
from win32com.client import Dispatch

aspire_ver = '9.0'

# Handle command line argument passing of labels.
argparser = argparse.ArgumentParser(description='Prints custom labels exported from Vectric Aspire.')
argparser.add_argument('-l', '--labels', action='store', dest='labels', required=True, help='List of comma separated labels to be printed.')
cmd_args = argparser.parse_args()

# Change working directory.
os.chdir('C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\Aspire V' + aspire_ver + '\\Label_Maker\\')

# COM port settings.
label_com = Dispatch('Dymo.DymoAddIn')
label_text = Dispatch('Dymo.DymoLabels')
label_com.SelectPrinter('DYMO LabelWriter 450')

# Iterate through given labels and print each one.
for label in cmd_args.labels.split(',')[:-1]:
    label_com.Open('my.label')
    label_text.SetField('LABEL', label)
    label_com.StartPrintJob()
    label_com.Print(1,False)
    label_com.EndPrintJob()