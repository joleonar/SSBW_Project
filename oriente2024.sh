#!/bin/sh

ps="oriente2024.ps"  #archivo ps de salida
r="-64.0/-60.5/10.0/11.5" 
proj="m1:2200000"

datos="datos_oriente2024.txt"

pscoast -R$r -J$proj -Di -W3.0 -Na -Ba1f0.5 -X1.0 -Y3.0 -K  -P > $ps
grdimage etopo1_bedrock.grd -R$r -J$proj -Cverde.cpt -E50 -O -K >> $ps

pscoast -R$r -J$proj -Df -W1.0 -Na -I2/0.25p,deepskyblue4 -Ba1f0.5:." ": -O -K -P >> $ps

#Plot Faults
psxy fallas2015.txt -J$proj -R$r -W1,red -O -V -K >> $ps

#Plot Cities
awk -F: '{print $2, $1}' ciuc.txt | psxy -Jm -R -Ss0.20 -G0 -W2 -L -K -O >> $ps
gawk -F: '{print $2, $1}' ciuc_oriente.txt | psxy -Jm -R -Ss0.15 -G0 -W2 -L -K -O >> $ps
gawk -F: '{print $5, $4-0.05, 12,0,5,2, $3}' ciuc.txt | pstext -Jm -R  -K -O >> $ps
gawk -F: '{print $5, $4-0.05,10,0,5,2, $3}' ciuc_oriente.txt | pstext -Jm -R  -K -O >> $ps

# Fault names
echo -63.80  10.39 FEP | pstext -Jm -R -F+f18p,Helvetica-Bold,white,+jCM -K -O -V >> $ps
echo -63.28  10.18 SFGSJ | pstext -Jm -R -F+f18p,Helvetica-Bold,white,+a-45,+jCM -K -O -V >> $ps
echo -62.58  10.12 FB | pstext -Jm -R -F+f18p,Helvetica-Bold,black,,+a-45+jCM -K -O -V >> $ps
echo -61.75  10.1 FES | pstext -Jm -R -F+f18p,Helvetica-Bold,black,+a-10,+jCM -K -O -V >> $ps
echo -61.20  10.1 FLB | pstext -Jm -R -F+f18p,Helvetica-Bold,black,+a-15,+jCM -K -O -V >> $ps

#Epicentros
awk '$6 < 3 {print $4, $3}'  $datos | psxy -J$proj -R$r -Sc0.15 -W0.5 -Ggreen -L -O -K >> $ps
awk '$6 >= 3 && $6 <4  {print $4, $3}'  $datos | psxy -J$proj -R$r -Sc0.20 -W0.5 -Gcyan -L -O -K >> $ps
awk '$6 >= 4 && $6 <5  {print $4, $3}'  $datos | psxy -J$proj -R$r -Sc0.30 -W0.5 -Gyellow  -L -O -K >> $ps
awk '$6 >= 5   {print $4, $3}'  $datos | psxy -J$proj -R$r -Sc0.40 -W0.5 -Gred  -L -O -K >> $ps

# LEGEND
pslegend -R -Jm -O -K -DjTR+w3.1c/2.8c+o0.2c -F+pthick+gazure1+r --FONT_ANNOT_PRIMARY=7p,Helvetica << EOF >> $ps
H 6 1 Magnitude (Mw)
G 0.1c
S 0.1c c 0.22c red    thin 0.35c >= 5.0
G 0.1c
S 0.1c c 0.20c yellow thin 0.35c between 4.0 y 4.9
G 0.1c
S 0.1c c 0.18c cyan   thin 0.35c between 3.0 y 3.9
G 0.1c
S 0.1c c 0.16c green  thin 0.35c < 3.0
G 0.20c
M 5 5 50+u
EOF

echo 0 0 | psxy -Jm -R -O >> $ps

#Convert ps to eps
ps2eps -f $ps

#Two way conver eps to png choose one of them
#convert -density 240 oriente2024.eps -trim -flatten oriente2024.png
#psconvert stations.eps -E600 -Tg
