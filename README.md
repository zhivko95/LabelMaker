# LabelMaker
Vectric Aspire plugin for managing and printing part labels stright from Aspire.

V1.0
-----
- Currently only supports labeling for rectangle based parts.
- Only tested on Aspire V9.0. (Should work on later versions as well but not tested)
- Only supports DYMO LabelWriter 450.
- Comes with premade basic label template which can be edited.


# Getting Started

- ## Installation
  
  Simply copy all of the files from the repository into a folder called "Label Maker" inside your Vectric Aspire Gadgets folder. (Usually located in Public Documents/Vectric Files/)

# Plugin Breakdown

- ## Add_Labels.lua

Handles the main part of the plugin dealing with displaying the dialog window and managing labels.

- ## AddLabels_dialog.htm

The main dialog of the plugin.

- ## Print_Labels.lua

Prints the previously stored labels by calling the python script "print_labels.py".

- ## Print Labels.py

Performs the actual setting up of the label printer and printing of the labels using the label template.

- ## my.label

The label template which dictates the style of the label.
