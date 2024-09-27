#!/bin/sh
gmtset MEASURE_UNIT cm   # change to cm

r="-82/-58/0/24"
proj="m1:20000000"
ps="stations.ps"

pscoast -R$r -J$proj -Df -W -Ba4f2/a4f2:."": -N1 -X1.0 -Y1.0 -G225 -P -K -V > $ps

pstext -R$r -J$proj -F+f16p,Helvetica-Bold,black -O -V -K <<END >> $ps
-68.0 15.0  Caribbean Sea
-67.0  8.0  Venezuela
END


# Stations from FUNVISIS networks
awk '{print $3, $2}' estaciones_fun.txt | psxy -R$r -J$proj -St0.35 -Gyellow -W -O -K -V >> $ps
awk '{print $3, $2+0.5, $1}' estaciones_fun.txt | pstext -J$proj -R$r -F+f6p,Helvetica -K -O -V >> $ps

# Stations from IU and CU networks
awk -F"|" '{print $5, $4}' wilber-stations2.txt | psxy -R$r -J$proj -St0.35 -h1 -Ggreen -W -O -K -V >> $ps
awk -F"|" '{print $5, $4+0.5, $1}' wilber-stations2.txt | pstext -J$proj -R$r -F+f6p,Helvetica -K -O -V >> $ps


# Epicenter Yaguarapato earthquake
echo -62.687 10.692 | psxy -R -Jm -Sa0.50 -Gred -W -O -V -K >> $ps

# LEGEND
pslegend -R -Jm -O -K -DjBL+w5.0c/2.5c+o0.2c -F+pthick+gazure1+r --FONT_ANNOT_PRIMARY=8p,Helvetica << EOF >> $ps
H 10 1 Seimological Stations
D 0.2c 1p
G 0.15c
S 0.25c t 0.5c yellow thin 1.0c Funvisis
G 0.2c
S 0.25c t 0.5c green  thin 1.0c IU/CU networks
G 0.2c
M 1 1 500+u
EOF

echo 0 0 | gmt psxy -Jm -R -O >> $ps

#Convert ps to eps
ps2eps -f $ps

# Convert to png
#psconvert stations.eps -E600 -Tg


