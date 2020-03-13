#!/bin/sh

for i in 21; 
do 
pdfcrop f${i}-best.pdf
pdfcrop f${i}-avg.pdf
for o in 100 200 500
do
pdfcrop f${i}-best-offset${o}.pdf
pdfcrop f${i}-avg-offset${o}.pdf
done
done
