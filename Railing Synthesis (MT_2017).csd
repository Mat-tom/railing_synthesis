
<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 128
nchnls = 2
0dbfs = 1.0

;================== RAILING SOUND PATCH (v.1.2) =====================

; Rappresentazione tramite metodi di analisi & re-sintesi dei suoni delle ringhiere, campane, molle ect.
; Patch sperimentale in continua via di sviluppo - stay connect!



; ----------------- Alunno: Matteo Tomasetti
; ----------------- Docente: Eugenio Giordani

; ----------------- A.A. 2016/2017 - L.E.M.S. (Laboratorio elettronico per la musica sperimentale)
; ----------------- Conservatorio G.Rossini (Pesaro) - Laurea triennale di I livello in "Musica Elettronica"



; ------------------ Good fun! -------------------------------



; Se notate errori o bugs per favore contattatemi a: tomsonfauster@hotmail.it



;============= Gestione e creazione delle tabelle (Gen) con TableEditor (funzione in CSound disponibile da Dicembre 2016) =====

giTableDecTime ftgen 0,0, 16, -7,0,16,50; tabella di distribuzione lineare dei decadimenti dei risonatori (tab 101)

giTableDecTime1 ftgen 0,0, 16, -7,0,8,50,8,0; tabella triangolo (tab 102)

giTableDecTime2 ftgen 0,0,1024, -7, 0, 73, 0.987879, 122, 0.390909, 77, 0.645455, 115, 0.896970, 92, 0.684848, 209, 0.054545, 121, 0.484848, 71, 0.693939, 107, 0.854545, 38, 1.000000; (disegnata con TableEditor)

giTableDecTime3 ftgen 0,0,1024, -7, 0.000000, 82, 1.000000, 258, 0.272727, 42, 0.696970, 34, 0.042424, 46, 0.757576, 69, 0.890909, 128, 0.709091, 78, 0.236364, 59, 0.593939, 96, 0.539394, 65, 0.054545, 65, 0.000000; (disegnata con TableEditor)

giTableDecTime4 ftgen 0,0,1024, -7, 0.000000, 122, 0.500000, 117, 0.939394, 57, 0.236364, 130, 1.000000, 69, 0.315152, 98, 0.015152, 52, 0.915152, 145, 0.115152, 78, 0.960606, 155, 0.003030

giTableDecTime5 ftgen 0,0,1024, -7, 0.000000, 31, 0.915152, 635, 0.939394, 358, 0.012121 ; stile Trapezio

giTableDecTime6 ftgen 0,0,1024, -7, 0.000000, 532, 1.000000, 492, 0.024242; Triangolo equilatero

giTableDecTime7 ftgen 0,0,1024, -7, 0.000000, 6, 0.969697, 297, 0.957576, 201, 0.018182, 98, 1.000000, 281, 0.963636, 142, 0.012121
; doppio trapezio con vuoto nel centro

giTableDecTime8 ftgen 0,0,1024, -7, 0.024242, 75, 0.915152, 82, 0.651515, 94, 0.933333, 283, 0.930303, 176, 0.521212, 84, 0.978788, 113, 0.969697, 117, 0.027273

giTableDecTime9 ftgen 0,0,1024, -7, 0.000000, 92, 0.703030, 142, 0.424242, 128, 0.145455, 42, 0.739394, 149, 0.545455, 6, 0.933333, 130, 0.406061, 86, 0.812121, 31, 0.048485, 168, 0.284848, 50, 0.000000

giTableDecTime10 ftgen 0,0,1024, -7, 0.003030, 567, 0.990909, 310, 0.972727, 147, 0.018182


;============= GENERAZIONE DELL'IMPULSO INIZIALE ( 1 solo impulso) =================


; NB ----- Ricordarsi sempre di inizializzare le variabili -----

gaSEND	init 0
gaFFTSEND init 0
gagate init 0
gaSENDres init 0
gaadsr init 0
gkadsr init 0
gkbwt1 init 0
gkbwt2 init 0
gkbwt3 init 0
gkbwt4 init 0
gkbwt5 init 0
gkbwt6 init 0
gkbwt7 init 0
gkbwt8 init 0
gkbwt9 init 0
gkbwt10 init 0
gkbwt11 init 0
gkbwt12 init 0
gkbwt13 init 0
gkbwt14 init 0
gkbwt15 init 0
gkbwt16 init 0

;gaoutputleft init 0
;gaoutputright init 0

instr 1

gkattack invalue "attack"
gkdur1 invalue "dur"
gksustain invalue "sustain"
gkrelease invalue "release"

gkpulse0 invalue "PULSE0"; primo impulso (slider) etc. etc.
gkpulse1 invalue "PULSE1"
gkpulse2 invalue "PULSE2"
gkpulse3 invalue "PULSE3"
gkpulse4 invalue "PULSE4"

gkp0s invalue "P0S" ; segno dell'impulso (+/-) nel widgets
gkp1s	invalue "P1S"
gkp2s	invalue "P2S"
gkp3s	invalue "P3S"
gkp4s	invalue "P4S"


gkmode invalue "MODE"; metodo di generazione, o solo uno oppure in modo continuo
gkpulselev invalue "PULSELEVEL"; livello di output dei 5 impulsi (globale)


gkp0s = (gkp0s !=1 ? 1: -1); se gkp0s (il segno) non è cliccato lascia così (positivo); altrimenti moltiplica per -1
gkp1s = (gkp1s !=1 ? 1 : -1)
gkp2s = (gkp2s !=1 ? 1 : -1)
gkp3s = (gkp3s !=1 ? 1 : -1)
gkp4s = (gkp4s !=1 ? 1 : -1)

gkdur invalue "DUR"
gkintv_0	invalue "INTV"; intervallo in millisecondi tra un impulso e un altro (da 10 ms a 200 ms) - slider

gkcut	invalue "CUT"; filtro applicabile in tutti gli impulsi
gkf0	invalue "F0" ; filtro 
gkbw	invalue "BW"; larghezza di banda
gkintv = gkintv_0 * 0.001

if gkmode == 1 then ; se è shot ti crea un impulso, se è run crea una sequenza di impulsi
gktrig metro 1/gkdur; crea una sequenza di eventi (treno di impulsi) - sarebbe un trigger metronome
schedkwhen gktrig,0,0,3,0,0.1; genera un evento di score (mettendolo alla durata dello schedkwhen te gli genera in quella durata)

schedkwhen gktrig, 0, 1, 29, 0, gkdur1
endif

endin


;gkbkw_00	invalue "bkw_00" - sarebbe se si volesse creare un impulso di varie ampiezze

instr 3

if gkmode == 0 then
schedule 29,0,0.1
endif

idur = i(gkdur)

ibw0 = i(gkbw); cambio di variabili, da g a i
kbw = ibw0 *0.01 * gkf0

ipulse_delay1 = i(gkintv); implementazione dell'intervallo (che è lineare, cioè per tutti i pulse l'intervallo è uguale)
ipulse_delay2 = 2 *ipulse_delay1
ipulse_delay3 = 3 *ipulse_delay1
ipulse_delay4 = 4 *ipulse_delay1

p3 = p3 * idur
a0 mpulse  gkpulselev, 1 ; generazione dell'impulsi e l'ampiezza è regolabile con il knob "pulse level output"

anoise rand 1; genera il noise con rand
anoise tonex anoise, gkcut ;filtra il segnale con lo slider "cut"
apulse_0 = a0 * gkpulse0 ;dichiarazione degli impulsi e nel widget son controllati dallo slider "pulse0" ect. ect.
apulse_1 delay a0*gkpulse1*gkp1s,ipulse_delay1; quà per il secondo moltiplica l'impulso per il segno e per il ritardo da "INTV"
apulse_2 delay a0*gkpulse2*gkp2s,ipulse_delay2
apulse_3 delay a0*gkpulse3*gkp3s,ipulse_delay3
apulse_4 delay a0*gkpulse4*gkp4s,ipulse_delay4

ap0 tonex apulse_0, gkcut ;implementazione del filtro e il cutoff è dato dallo slider "filter cut"
ap1 tonex apulse_1, gkcut
ap2 tonex apulse_2, gkcut * 0.7
ap3 tonex apulse_3, gkcut * 0.7^2
ap4 tonex apulse_4, gkcut * 0.7^3	

asump = (ap0+ap1+ap2+ap3+ap4)* anoise* 10 ; somma degli impulsi moltiplicati per il noise

a1_MID resonr asump, gkf0, kbw, 1 ; uscita nuova degli impulsi che passano dentro il filtro passabanda controllabile da widgets

gaSEND = gaSEND + a1_MID * 32 ;variabile globale: moltiplica il tutto (uscita)

;outs 40*gaSEND, 40*gaSEND

gaSENDres = gaSENDres + a1_MID*32

gaFFTSEND = gaFFTSEND + gaSEND
clear gaSEND

endin



instr 100

ain = gaFFTSEND 
dispfft ain+0.001, 0.01, 1024,1
clear gaFFTSEND

endin



instr 29
idur1 = p3

if idur1 > i(gkdur) then

idur1 = i(gkdur)
p3 = idur1

endif

;gaadsr adsr i(gkattack),i(gkdecay), i(gksustain), i(gkrelease )
gkadsr linen i(gksustain),i(gkattack), idur1, i(gkrelease)
outvalue "display0", gkadsr


;printk2 gkadsr

endin



instr 30


;kfr1 init 440
kbw1 invalue "BWres1"
gkampres1 invalue "ampres1"
gkampres2 invalue "ampres2"
gkampres3 invalue "ampres3"
gkampres4 invalue "ampres4"
gkampres5 invalue "ampres5"
gkampres6 invalue "ampres6"
gkampres7 invalue "ampres7"
gkampres8 invalue "ampres8"
gkampres9 invalue "ampres9"
gkampres10 invalue "ampres10"
gkampres11 invalue "ampres11"
gkampres12 invalue "ampres12"
gkampres13 invalue "ampres13"
gkampres14 invalue "ampres14"
gkampres15 invalue "ampres15"
gkampres16 invalue "ampres16"



gktablemenu invalue "tablemenu"

gkf0res1 invalue "f0res1"
gkf0res2 invalue "f0res2"
gkf0res3 invalue "f0res3"
gkf0res4 invalue "f0res4"
gkf0res5 invalue "f0res5"
gkf0res6 invalue "f0res6"
gkf0res7 invalue "f0res7"
gkf0res8 invalue "f0res8"
gkf0res9 invalue "f0res9"
gkf0res10 invalue "f0res10"
gkf0res11 invalue "f0res11"
gkf0res12 invalue "f0res12"
gkf0res13 invalue "f0res13"
gkf0res14 invalue "f0res14"
gkf0res15 invalue "f0res15"
gkf0res16 invalue "f0res16"
gkmodlfo invalue "lfomodulation"



ain = gaSENDres

ar1 resonr ain*gkampres1, gkf0res1, kbw1+gkbwt1
ar2 resonr ain*gkampres2, gkf0res2, kbw1+gkbwt2
ar3 resonr ain*gkampres3, gkf0res3, kbw1+gkbwt3
ar4 resonr ain*gkampres4, gkf0res4, kbw1+gkbwt4
ar5 resonr ain*gkampres5, gkf0res5, kbw1+gkbwt5
ar6 resonr ain*gkampres6, gkf0res6, kbw1+gkbwt6
ar7 resonr ain*gkampres7, gkf0res7, kbw1+gkbwt7
ar8 resonr ain*gkampres8, gkf0res8, kbw1+gkbwt8
ar9 resonr ain*gkampres9, gkf0res9, kbw1+gkbwt9
ar10 resonr ain*gkampres10, gkf0res10, kbw1+gkbwt10
ar11 resonr ain*gkampres11, gkf0res11, kbw1+gkbwt11
ar12 resonr ain*gkampres12, gkf0res12, kbw1+gkbwt12
ar13 resonr ain*gkampres13, gkf0res13, kbw1+gkbwt13
ar14 resonr ain*gkampres14, gkf0res14, kbw1+gkbwt14
ar15 resonr ain*gkampres15, gkf0res15, kbw1+gkbwt15
ar16 resonr ain*gkampres16, gkf0res16, kbw1+gkbwt16
;printk2 kbw1+gkbwt1


kdelayline invalue "delay"

adelayline = a(kdelayline)

adr1 vdelay ar1, adelayline, 2000
adr2 vdelay ar2, adelayline*10, 2000
adr3 vdelay ar3, adelayline*12, 2000
adr4 vdelay ar4, adelayline*14, 2000
adr5 vdelay ar5, adelayline*20, 2000
adr6 vdelay ar6, adelayline*26, 2000
adr7 vdelay ar7, adelayline*30, 2000
adr8 vdelay ar8, adelayline*32, 2000
adr9 vdelay ar9, adelayline*34, 2000
adr10 vdelay ar10, adelayline*40, 2000
adr11 vdelay ar11, adelayline*42, 2000
adr12 vdelay ar12, adelayline*45, 2000
adr13 vdelay ar13, adelayline*47, 2000
adr14 vdelay ar14, adelayline*48, 2000
adr15 vdelay ar15, adelayline*49, 2000
adr16 vdelay ar16, adelayline*51, 2000

asumR = (adr1+adr2+adr3+adr4+adr5+adr6+adr7+adr8+adr9+adr10+adr11+adr12+adr13+adr14+adr15+adr16)*0.030


asumrlfo lfo 0.5, gkmodlfo, 0


gaoutputleft = (asumR* (1+asumrlfo)*gkadsr)*0.2
gaoutputright = (asumR*(1+asumrlfo)*gkadsr)*0.2

;outs gaoutputleft, gaoutputright
;outs asig1, asig2 ar1*0.5, ar1*0.5


gkdec invalue "dec"				;controlli del riverbero (instrument 8 - di seguito)
gkhf invalue "hf"
gkonoff invalue "mute"

clear gaSENDres

endin


instr 4

outvalue "f0res1", 120
outvalue "f0res2", 240
outvalue "f0res2", 240
outvalue "f0res3", 360
outvalue "f0res4", 480
outvalue "f0res5", 600
outvalue "f0res6", 720
outvalue "f0res7", 840
outvalue "f0res8", 960
outvalue "f0res9", 1080
outvalue "f0res10", 1200
outvalue "f0res11", 1320
outvalue "f0res12", 1440
outvalue "f0res13", 1560
outvalue "f0res14", 1680
outvalue "f0res15", 1800
outvalue "f0res16", 1920


endin


instr 27 ;Fibonacci frequencies: 110=x     x*1,618=y ---> 178 HZ     y*1.618=z ----> 288 e così via cioè: 220=x   x*1.618 ect. ect.

outvalue "f0res1", 110
outvalue "f0res2", 178
outvalue "f0res2", 288
outvalue "f0res3", 220
outvalue "f0res4", 356
outvalue "f0res5", 576
outvalue "f0res6", 330
outvalue "f0res7", 534
outvalue "f0res8", 864
outvalue "f0res9", 440
outvalue "f0res10", 712
outvalue "f0res11", 1152
outvalue "f0res12", 550
outvalue "f0res13", 890
outvalue "f0res14", 660
outvalue "f0res15", 1068
outvalue "f0res16", 1728

endin

instr 28; frequenze a partire da 55 Hz (A1) inarmoniche moltiplicate per 2,2 (frequenze/parziali inarmoniche) ---> ogni 3

outvalue "f0res1", 55
outvalue "f0res2", 121
outvalue "f0res2", 266
outvalue "f0res3", 585
outvalue "f0res4", 1287
outvalue "f0res5", 110
outvalue "f0res6", 242
outvalue "f0res7", 532
outvalue "f0res8", 1171
outvalue "f0res9", 220
outvalue "f0res10", 484
outvalue "f0res11", 1064
outvalue "f0res12", 2342
outvalue "f0res13", 440
outvalue "f0res14", 968
outvalue "f0res15", 2129
outvalue "f0res16", 4685

endin

instr 36; frequenze inarmoniche: 20=x   x*3.14=y --- 2°= 40=x  x*3.14=y ---- 3°= 60=x   x*3.14=y ---- ect. ect.

outvalue "f0res1", 20
outvalue "f0res2", 63
outvalue "f0res2", 40
outvalue "f0res3", 126
outvalue "f0res4", 60
outvalue "f0res5", 188
outvalue "f0res6", 80
outvalue "f0res7", 251
outvalue "f0res8", 100
outvalue "f0res9", 314
outvalue "f0res10", 120
outvalue "f0res11", 377
outvalue "f0res12", 140
outvalue "f0res13", 440
outvalue "f0res14", 160
outvalue "f0res15", 502
outvalue "f0res16", 180

endin

instr 31; serie armonica di Do ((66HZ)

outvalue "f0res1", 66
outvalue "f0res2", 132
outvalue "f0res2", 198
outvalue "f0res3", 264
outvalue "f0res4", 330
outvalue "f0res5", 396
outvalue "f0res6", 462
outvalue "f0res7", 528
outvalue "f0res8", 594
outvalue "f0res9", 660
outvalue "f0res10", 726
outvalue "f0res11", 792
outvalue "f0res12", 858
outvalue "f0res13", 924
outvalue "f0res14", 990
outvalue "f0res15", 1056
outvalue "f0res16", 1122

endin

instr 32; serie geometrica inarmonica : 50 Hz * 2.35 ((ogni tre, come prima)))

outvalue "f0res1", 50
outvalue "f0res2", 117
outvalue "f0res2", 276
outvalue "f0res3", 648
outvalue "f0res4", 1524
outvalue "f0res5", 100
outvalue "f0res6", 235
outvalue "f0res7", 552
outvalue "f0res8", 1298
outvalue "f0res9", 150
outvalue "f0res10", 352
outvalue "f0res11", 828
outvalue "f0res12", 1947
outvalue "f0res13", 200
outvalue "f0res14", 470
outvalue "f0res15", 1104
outvalue "f0res16", 2596

endin



; mettere tanti risuonatori (tipo 12) e metterli in parallelo nel senso che l'entrata deve essere sempre "ain" e poi
; alla fine l'uscita è la somma di tutti questi risuonatori
; consigliabile metterci anche un lfo che gli modula e per creare decorellazione nel tempo metterci un delay altrimenti
; ad ogni impulso risponderebbero tutti nello stesso momento e invece devono essere correlati e creare anche la g formula perche ;non devono rispettare la serie armonica

instr 5

itab = i(gktablemenu)
print itab, giTableDecTime+itab

gkbwt1 table 0, giTableDecTime+itab, 1
gkbwt2 table 1/15, giTableDecTime+itab, 1
gkbwt3 table 2/15, giTableDecTime+itab, 1
gkbwt4 table 3/15, giTableDecTime+itab, 1
gkbwt5 table 4/15, giTableDecTime+itab, 1
gkbwt6 table 5/15, giTableDecTime+itab, 1
gkbwt7 table 6/15, giTableDecTime+itab, 1
gkbwt8 table 7/15, giTableDecTime+itab, 1
gkbwt9 table 8/15, giTableDecTime+itab, 1
gkbwt10 table 9/15, giTableDecTime+itab, 1
gkbwt11 table 10/15, giTableDecTime+itab, 1
gkbwt12 table 11/15, giTableDecTime+itab, 1
gkbwt13 table 12/15, giTableDecTime+itab, 1
gkbwt14 table 13/15, giTableDecTime+itab, 1
gkbwt15 table 14/15, giTableDecTime+itab, 1
gkbwt16 table 15/15, giTableDecTime+itab, 1

printk2 gkbwt8

endin

instr 8 ;======================== MASTER REVERB (using Freeverb opcode) ===============================

ainL = gaoutputleft
ainR = gaoutputright

garevL, garevR freeverb ainL, ainR, gkdec, gkhf            ;riverbero

gkmuto = (gkonoff >= 1? 1 : 0)

gkmute port gkmuto, 0.1

;outs arevL*kmute, arevR*kmute


endin


instr 47; prova FM moltiplicata all'output audio creato anteriormente



gkamplitudefm invalue "amplitudefm"
gkfreqmod invalue "freqmod"
gkindice invalue "indicemod"
gkportante invalue "portante"


;gkindiceenv linseg 0, 2, 1, 2, 0

afmoutputleft foscili gkamplitudefm*gkadsr, 1, gkportante, gkfreqmod, gkindice, 1
afmoutputright foscili gkamplitudefm*gkadsr, 1, gkportante, gkfreqmod, gkindice, 1

outs afmoutputleft+gkmute*garevL+gaoutputleft, afmoutputright+gkmute*garevR+gaoutputright


endin



</CsInstruments>

<CsScore>

f 1 0 16384 10 1; sine per la FM

i1 0 3600
i20 0 3600
i100 0 3600
i30 0 3600
i8	0	3600
i47 0 3600

</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>155</x>
 <y>1164</y>
 <width>1647</width>
 <height>966</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="background">
  <r>237</r>
  <g>233</g>
  <b>189</b>
 </bgcolor>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>PULSE0</objectName>
  <x>336</x>
  <y>6</y>
  <width>47</width>
  <height>110</height>
  <uuid>{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.66000003</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>PULSE1</objectName>
  <x>435</x>
  <y>6</y>
  <width>45</width>
  <height>110</height>
  <uuid>{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.69000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>PULSE2</objectName>
  <x>520</x>
  <y>7</y>
  <width>44</width>
  <height>110</height>
  <uuid>{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.40000001</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>PULSE3</objectName>
  <x>611</x>
  <y>7</y>
  <width>43</width>
  <height>110</height>
  <uuid>{374dbca9-a526-4d0e-b5e3-90478049b6bf}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.77999997</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>322</x>
  <y>122</y>
  <width>86</width>
  <height>40</height>
  <uuid>{822b857e-a114-4f74-8b2b-5d41301b12b2}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Pulse #0</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>26</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>417</x>
  <y>122</y>
  <width>84</width>
  <height>40</height>
  <uuid>{3e76792f-cfec-4bd7-99eb-1e1a131ed8c2}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>PULSE #1</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>26</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>503</x>
  <y>122</y>
  <width>84</width>
  <height>40</height>
  <uuid>{80b9f4b0-35c4-4831-b1a2-2069ef731745}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>PULSE #2</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>26</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>593</x>
  <y>121</y>
  <width>86</width>
  <height>42</height>
  <uuid>{22aed010-6ac0-4992-83cf-023178d4f1b0}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>PULSE #3</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>26</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>PULSE4</objectName>
  <x>694</x>
  <y>7</y>
  <width>44</width>
  <height>110</height>
  <uuid>{056dbef4-8826-4d69-8e6a-852c4edc2ea8}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.58999997</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>682</x>
  <y>120</y>
  <width>93</width>
  <height>43</height>
  <uuid>{5c5d9527-0014-497b-89b3-c35636f04f44}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>PULSE #4
</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>26</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>P1S</objectName>
  <x>437</x>
  <y>158</y>
  <width>40</width>
  <height>30</height>
  <uuid>{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <type>value</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>+/-</text>
  <image>/</image>
  <eventLine>i1 0 10</eventLine>
  <latch>true</latch>
  <latched>false</latched>
  <fontsize>10</fontsize>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>P2S</objectName>
  <x>526</x>
  <y>158</y>
  <width>40</width>
  <height>30</height>
  <uuid>{567bc827-d2f8-4b4e-b381-3ae13d4fb944}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <type>value</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>+/-</text>
  <image>/</image>
  <eventLine>i1 0 10</eventLine>
  <latch>true</latch>
  <latched>false</latched>
  <fontsize>10</fontsize>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>P3S</objectName>
  <x>616</x>
  <y>158</y>
  <width>40</width>
  <height>30</height>
  <uuid>{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <type>value</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>+/-</text>
  <image>/</image>
  <eventLine>i1 0 10</eventLine>
  <latch>true</latch>
  <latched>false</latched>
  <fontsize>10</fontsize>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>P4S</objectName>
  <x>707</x>
  <y>159</y>
  <width>40</width>
  <height>30</height>
  <uuid>{b4443073-2b51-40c0-8fca-12617e9d2814}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <type>value</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>+/-</text>
  <image>/</image>
  <eventLine>i1 0 10</eventLine>
  <latch>true</latch>
  <latched>false</latched>
  <fontsize>10</fontsize>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>P0S</objectName>
  <x>343</x>
  <y>158</y>
  <width>40</width>
  <height>30</height>
  <uuid>{b74c7428-7e0a-4534-9721-84f928b784f0}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <type>value</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>+/-</text>
  <image>/</image>
  <eventLine>i1 0 10</eventLine>
  <latch>true</latch>
  <latched>false</latched>
  <fontsize>10</fontsize>
 </bsbObject>
 <bsbObject type="BSBKnob" version="2">
  <objectName>PULSELEVEL</objectName>
  <x>1039</x>
  <y>27</y>
  <width>80</width>
  <height>80</height>
  <uuid>{34836809-f2ae-40bf-83f4-70afd41e31d5}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.74000001</value>
  <mode>lin</mode>
  <mouseControl act="">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
  <color>
   <r>245</r>
   <g>124</g>
   <b>0</b>
  </color>
  <textcolor>#512900</textcolor>
  <border>0</border>
  <borderColor>#512900</borderColor>
  <showvalue>true</showvalue>
  <flatstyle>true</flatstyle>
  <integerMode>false</integerMode>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>1006</x>
  <y>109</y>
  <width>139</width>
  <height>85</height>
  <uuid>{70eb9bb9-e4fd-4e30-94c4-86bd02e1c0d3}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>PULSE LEVEL OUTPUT
</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>22</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>INTV</objectName>
  <x>872</x>
  <y>7</y>
  <width>41</width>
  <height>110</height>
  <uuid>{1feef608-a361-4450-ab55-7696af9b3ae4}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.50000000</minimum>
  <maximum>2.00000000</maximum>
  <value>0.78636364</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>802</x>
  <y>122</y>
  <width>203</width>
  <height>53</height>
  <uuid>{9334256b-93c5-4154-b6ed-6b6073212045}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Impulse Intervals</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Lucida Grande</font>
  <fontsize>26</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>false</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>CUT</objectName>
  <x>216</x>
  <y>244</y>
  <width>41</width>
  <height>105</height>
  <uuid>{c78a7996-cc03-400d-b5c3-0345e930d720}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>100.00000000</minimum>
  <maximum>12000.00000000</maximum>
  <value>8311.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>186</x>
  <y>347</y>
  <width>105</width>
  <height>62</height>
  <uuid>{93dc3025-38ee-492a-b30d-f029df1627c8}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>FILTER CUT</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>24</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>F0</objectName>
  <x>333</x>
  <y>245</y>
  <width>40</width>
  <height>103</height>
  <uuid>{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>100.00000000</minimum>
  <maximum>4000.00000000</maximum>
  <value>554.36893204</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>323</x>
  <y>348</y>
  <width>60</width>
  <height>40</height>
  <uuid>{c4d6f635-68bf-4e66-a909-aeab3c5f7385}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>F0</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>30</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>BW</objectName>
  <x>456</x>
  <y>245</y>
  <width>41</width>
  <height>103</height>
  <uuid>{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>1.00000000</minimum>
  <maximum>150.00000000</maximum>
  <value>150.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>442</x>
  <y>346</y>
  <width>156</width>
  <height>76</height>
  <uuid>{5c2a5f54-f6a0-4b3f-8c15-5f198214e1a3}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>FILTER BANDWIDTH</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>26</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDropdown" version="2">
  <objectName>MODE</objectName>
  <x>186</x>
  <y>63</y>
  <width>80</width>
  <height>30</height>
  <uuid>{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <bsbDropdownItemList>
   <bsbDropdownItem>
    <name>SHOT</name>
    <value>0</value>
    <stringvalue/>
   </bsbDropdownItem>
   <bsbDropdownItem>
    <name> RUN</name>
    <value>1</value>
    <stringvalue/>
   </bsbDropdownItem>
  </bsbDropdownItemList>
  <selectedIndex>1</selectedIndex>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>187</x>
  <y>25</y>
  <width>118</width>
  <height>37</height>
  <uuid>{aab21b5b-e1af-4b07-b710-abedd5099d1a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>BANG MODE</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>28</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>BANG</objectName>
  <x>11</x>
  <y>14</y>
  <width>148</width>
  <height>74</height>
  <uuid>{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <type>event</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>BANG
PULSE FOR START</text>
  <image>/</image>
  <eventLine>i3 0 0.1</eventLine>
  <latch>false</latch>
  <latched>false</latched>
  <fontsize>10</fontsize>
 </bsbObject>
 <bsbObject type="BSBScope" version="2">
  <objectName/>
  <x>1180</x>
  <y>173</y>
  <width>350</width>
  <height>150</height>
  <uuid>{3dbe21c8-d134-48a2-a35d-06b231b2d800}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <value>-255.00000000</value>
  <type>scope</type>
  <zoomx>2.00000000</zoomx>
  <zoomy>1.00000000</zoomy>
  <dispx>1.00000000</dispx>
  <dispy>1.00000000</dispy>
  <mode>0.00000000</mode>
 </bsbObject>
 <bsbObject type="BSBGraph" version="2">
  <objectName/>
  <x>1175</x>
  <y>11</y>
  <width>350</width>
  <height>150</height>
  <uuid>{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <value>0</value>
  <objectName2/>
  <zoomx>1.00000000</zoomx>
  <zoomy>1.00000000</zoomy>
  <dispx>1.00000000</dispx>
  <dispy>1.00000000</dispy>
  <modex>lin</modex>
  <modey>lin</modey>
  <showSelector>true</showSelector>
  <showGrid>true</showGrid>
  <showTableInfo>true</showTableInfo>
  <showScrollbars>true</showScrollbars>
  <enableTables>true</enableTables>
  <enableDisplays>true</enableDisplays>
  <all>true</all>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>DUR</objectName>
  <x>57</x>
  <y>104</y>
  <width>40</width>
  <height>100</height>
  <uuid>{1fba5c43-d60e-49dc-8e1f-34467529754f}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.10000000</minimum>
  <maximum>3.00000000</maximum>
  <value>3.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>29</x>
  <y>204</y>
  <width>135</width>
  <height>74</height>
  <uuid>{98e855dc-bb6c-40a9-9a71-865eb0b02fe6}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Generation's Velocity</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>28</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>BWres1</objectName>
  <x>693</x>
  <y>250</y>
  <width>40</width>
  <height>100</height>
  <uuid>{57e07eec-f065-407f-bc8b-652ff42dd6da}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.50000000</minimum>
  <maximum>50.00000000</maximum>
  <value>0.50000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>635</x>
  <y>350</y>
  <width>163</width>
  <height>79</height>
  <uuid>{557efac6-8d43-4473-8be8-d895b72f6fe2}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>RESONATORS BW</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>26</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>delay</objectName>
  <x>874</x>
  <y>246</y>
  <width>50</width>
  <height>100</height>
  <uuid>{f4be3e35-886e-4424-96f9-a8caee28dace}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>300.00000000</maximum>
  <value>0.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>838</x>
  <y>352</y>
  <width>158</width>
  <height>62</height>
  <uuid>{b28cd959-7b1e-4f9f-9868-bfdc22f8c893}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Resonators Delay (ms)
(RANDOM)
</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>22</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBScrollNumber" version="2">
  <objectName>delay</objectName>
  <x>876</x>
  <y>216</y>
  <width>40</width>
  <height>25</height>
  <uuid>{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <value>0.00000000</value>
  <resolution>0.01000000</resolution>
  <minimum>-999999999999.00000000</minimum>
  <maximum>999999999999.00000000</maximum>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
  <randomizable group="0">false</randomizable>
  <mouseControl act=""/>
 </bsbObject>
 <bsbObject type="BSBKnob" version="2">
  <objectName>lfomodulation</objectName>
  <x>1042</x>
  <y>242</y>
  <width>80</width>
  <height>80</height>
  <uuid>{e9d00afa-2d17-4143-aae7-0a9add2429a8}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00100000</minimum>
  <maximum>500.00000000</maximum>
  <value>420.00016000</value>
  <mode>lin</mode>
  <mouseControl act="">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
  <color>
   <r>245</r>
   <g>124</g>
   <b>0</b>
  </color>
  <textcolor>#512900</textcolor>
  <border>0</border>
  <borderColor>#512900</borderColor>
  <showvalue>true</showvalue>
  <flatstyle>true</flatstyle>
  <integerMode>false</integerMode>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>1032</x>
  <y>325</y>
  <width>130</width>
  <height>70</height>
  <uuid>{fa423782-f6a1-4728-948d-d34f4b184baa}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>LFO Modulation
</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>22</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBScrollNumber" version="2">
  <objectName>BW</objectName>
  <x>456</x>
  <y>218</y>
  <width>43</width>
  <height>25</height>
  <uuid>{f63e36a9-4510-4b12-bd82-62fa0686ba4f}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <value>150.00000000</value>
  <resolution>0.01000000</resolution>
  <minimum>-999999999999.00000000</minimum>
  <maximum>999999999999.00000000</maximum>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
  <randomizable group="0">false</randomizable>
  <mouseControl act=""/>
 </bsbObject>
 <bsbObject type="BSBScrollNumber" version="2">
  <objectName>F0</objectName>
  <x>330</x>
  <y>218</y>
  <width>50</width>
  <height>25</height>
  <uuid>{48dcad2d-eb3e-42a7-9793-ed2e19355426}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <value>554.36893204</value>
  <resolution>0.01000000</resolution>
  <minimum>-999999999999.00000000</minimum>
  <maximum>999999999999.00000000</maximum>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
  <randomizable group="0">false</randomizable>
  <mouseControl act=""/>
 </bsbObject>
 <bsbObject type="BSBScrollNumber" version="2">
  <objectName>CUT</objectName>
  <x>214</x>
  <y>216</y>
  <width>50</width>
  <height>25</height>
  <uuid>{6f061ce3-ab4b-4e1a-853f-42e97952075c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <value>8311.00000000</value>
  <resolution>0.01000000</resolution>
  <minimum>-999999999999.00000000</minimum>
  <maximum>999999999999.00000000</maximum>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
  <randomizable group="0">false</randomizable>
  <mouseControl act=""/>
 </bsbObject>
 <bsbObject type="BSBScrollNumber" version="2">
  <objectName>BWres1</objectName>
  <x>694</x>
  <y>217</y>
  <width>42</width>
  <height>24</height>
  <uuid>{52f30728-cf31-43c5-abd5-9968e6f45bae}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <value>0.50000000</value>
  <resolution>0.01000000</resolution>
  <minimum>-999999999999.00000000</minimum>
  <maximum>999999999999.00000000</maximum>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
  <randomizable group="0">false</randomizable>
  <mouseControl act=""/>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>37</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{8fbfc604-cefd-40f0-978e-57c71d3aa42c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres1</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.88461536</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>147</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{aa973b41-23db-4e4f-9890-2cb7530f2edf}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres11</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.57692307</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>136</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{ca2443b6-4419-45be-a836-472c81948c61}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres10</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.33076924</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>125</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{e8a03819-128d-45e0-b85e-cb6c6e89039b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres1</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.88461536</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>125</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres9</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.43076923</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>114</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{ed3ea933-b022-4420-b8ca-19950d71ccf5}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres8</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.55384612</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>103</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{ac312a98-f135-44cf-8ce3-ad847bf64347}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres7</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.41538462</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>92</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{b26dee23-b9c0-472c-9061-8460e6d93a16}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres6</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.53076923</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>81</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{7d3f5026-3f30-457e-9c95-fa7b198db30c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres1</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.88461536</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>81</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{7a287fab-a25c-4bcc-97f4-589e7bc33815}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres5</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.69999999</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>70</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{82806551-10c5-4bf1-8fa7-f33f6187925d}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres4</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.48461539</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>59</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{6a641948-52e5-436a-a1a8-4d6e9624af58}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres3</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.74615383</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>48</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres2</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.89230770</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>158</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{5aefaf87-d5c7-4192-963a-21dcc17ad71a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres12</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.33076924</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>24</x>
  <y>679</y>
  <width>203</width>
  <height>47</height>
  <uuid>{29d67218-e7c7-412d-a20c-713b7c5ca039}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Amplitude Of 16 Resonators</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>18</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>299</x>
  <y>701</y>
  <width>519</width>
  <height>83</height>
  <uuid>{db3f0f56-4f8c-46a6-b7d3-1f6d5609e589}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Central Frequency Of 16 Resonators</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>32</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>302</x>
  <y>547</y>
  <width>20</width>
  <height>150</height>
  <uuid>{9c339096-fef3-491f-986b-d0713ce399fa}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res2</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>4000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>386.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>332</x>
  <y>546</y>
  <width>20</width>
  <height>150</height>
  <uuid>{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res3</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>4000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>412.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>371</x>
  <y>547</y>
  <width>20</width>
  <height>150</height>
  <uuid>{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res4</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>4000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>620.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>406</x>
  <y>548</y>
  <width>20</width>
  <height>150</height>
  <uuid>{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res5</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>4000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>178.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>440</x>
  <y>548</y>
  <width>20</width>
  <height>150</height>
  <uuid>{72b6ed4d-3606-48c4-887d-395c2e06460c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res6</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>4000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>308.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>476</x>
  <y>547</y>
  <width>20</width>
  <height>150</height>
  <uuid>{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res7</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>4000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>308.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>513</x>
  <y>547</y>
  <width>20</width>
  <height>150</height>
  <uuid>{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res8</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>4000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>516.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>551</x>
  <y>547</y>
  <width>20</width>
  <height>150</height>
  <uuid>{6f99cab0-849b-4c31-a4ae-06202e4ee880}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res9</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>4000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>256.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>582</x>
  <y>548</y>
  <width>20</width>
  <height>150</height>
  <uuid>{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res10</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>4000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>542.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>621</x>
  <y>550</y>
  <width>20</width>
  <height>150</height>
  <uuid>{382f8eab-c306-4ac0-8fb6-4a7467c55c22}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res11</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>4000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>464.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>265</x>
  <y>546</y>
  <width>20</width>
  <height>150</height>
  <uuid>{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res1</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>4000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>750.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>656</x>
  <y>547</y>
  <width>20</width>
  <height>150</height>
  <uuid>{9b16c998-3126-4e53-92a1-37e0c79ef4fa}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res12</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>4000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>308.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res1</objectName>
  <x>258</x>
  <y>514</y>
  <width>36</width>
  <height>29</height>
  <uuid>{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>750.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res2</objectName>
  <x>294</x>
  <y>514</y>
  <width>36</width>
  <height>29</height>
  <uuid>{af2791a7-0178-4cf1-8f49-b21f3434c8cd}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>386.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res3</objectName>
  <x>330</x>
  <y>514</y>
  <width>36</width>
  <height>29</height>
  <uuid>{7d292521-72cb-4ae6-ba97-df1f42ff8343}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>412.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res4</objectName>
  <x>363</x>
  <y>514</y>
  <width>36</width>
  <height>29</height>
  <uuid>{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>620.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res5</objectName>
  <x>399</x>
  <y>514</y>
  <width>36</width>
  <height>29</height>
  <uuid>{b3a1c166-05e7-41ff-9d68-cbadcd3db944}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>178.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res6</objectName>
  <x>435</x>
  <y>514</y>
  <width>36</width>
  <height>29</height>
  <uuid>{6a9972e0-4af8-4660-a447-2ca723958d91}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>308.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res7</objectName>
  <x>470</x>
  <y>514</y>
  <width>36</width>
  <height>29</height>
  <uuid>{31b0f180-920c-461b-a45d-4f3ae7721d52}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>308.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res8</objectName>
  <x>506</x>
  <y>514</y>
  <width>36</width>
  <height>29</height>
  <uuid>{18dd5e8a-380a-44ea-8d7f-d628047abfdc}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>516.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res9</objectName>
  <x>543</x>
  <y>515</y>
  <width>36</width>
  <height>29</height>
  <uuid>{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>256.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res10</objectName>
  <x>579</x>
  <y>515</y>
  <width>36</width>
  <height>29</height>
  <uuid>{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>542.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res11</objectName>
  <x>614</x>
  <y>516</y>
  <width>36</width>
  <height>29</height>
  <uuid>{1716e36b-17ff-4d82-af74-74fdf8081999}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>464.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res12</objectName>
  <x>651</x>
  <y>517</y>
  <width>36</width>
  <height>29</height>
  <uuid>{c4ed3184-82bb-4136-886d-023e39b38405}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>308.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>attack</objectName>
  <x>1206</x>
  <y>621</y>
  <width>35</width>
  <height>104</height>
  <uuid>{bf83e1da-fb92-4782-b291-79f2fadbc31b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00100000</minimum>
  <maximum>2.00000000</maximum>
  <value>0.00100000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>sustain</objectName>
  <x>1432</x>
  <y>620</y>
  <width>24</width>
  <height>103</height>
  <uuid>{b29455b4-1f35-4da7-b6e3-1d26749f211b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00100000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.46655340</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>release</objectName>
  <x>1553</x>
  <y>619</y>
  <width>29</width>
  <height>102</height>
  <uuid>{019ab94d-9192-4b84-9baa-480b3d8a287a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.20000000</minimum>
  <maximum>2.00000000</maximum>
  <value>1.75294118</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>1167</x>
  <y>723</y>
  <width>113</width>
  <height>47</height>
  <uuid>{6c9b81ef-c524-4f34-a292-df18a0a115c5}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Attack (ms)</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>30</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>1390</x>
  <y>721</y>
  <width>119</width>
  <height>46</height>
  <uuid>{07d86b1e-ffaf-43a3-aae5-9f433d492dcf}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Sustain AMP</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>30</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>1516</x>
  <y>722</y>
  <width>119</width>
  <height>44</height>
  <uuid>{3a9e2d8d-06c7-4a7b-aafa-6d7bfa016d12}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Release (ms)</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>30</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>attack</objectName>
  <x>1204</x>
  <y>591</y>
  <width>38</width>
  <height>26</height>
  <uuid>{5b47c229-d87c-4754-9da0-ac04c61bf1cb}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>0.001</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>sustain</objectName>
  <x>1423</x>
  <y>591</y>
  <width>40</width>
  <height>28</height>
  <uuid>{7d1ae936-c4df-435e-b54e-81868d9b0a63}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>0.467</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>release</objectName>
  <x>1545</x>
  <y>591</y>
  <width>40</width>
  <height>26</height>
  <uuid>{3eb76da8-fb74-4ef5-b074-0e13106c122b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>1.753</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>169</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{7df7694b-f289-49e1-a56a-a310756050d5}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres13</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.55384618</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>180</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres14</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.19230769</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>191</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{43c2de00-77ce-4af4-98e4-e3b79e44e83f}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres15</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.09230769</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>202</x>
  <y>545</y>
  <width>11</width>
  <height>130</height>
  <uuid>{da17ed9a-3cf6-498b-80e9-4dca2b07a681}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>ampres16</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.06153846</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>697</x>
  <y>547</y>
  <width>20</width>
  <height>150</height>
  <uuid>{91a5983c-29a5-4128-8744-9d2b1de044b8}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res13</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>15000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>1292.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res13</objectName>
  <x>688</x>
  <y>518</y>
  <width>42</width>
  <height>27</height>
  <uuid>{40c35667-3c45-4aa9-b70e-61028d03ea5a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>1292.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>740</x>
  <y>546</y>
  <width>20</width>
  <height>150</height>
  <uuid>{f2568038-e70d-48e0-973a-88204d4d431c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res14</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>15000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>795.33331299</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res14</objectName>
  <x>731</x>
  <y>518</y>
  <width>42</width>
  <height>29</height>
  <uuid>{cad9ff50-0f2a-450e-85eb-2f47f89d5612}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>795.333</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>784</x>
  <y>547</y>
  <width>20</width>
  <height>150</height>
  <uuid>{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res15</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>15000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>696.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res15</objectName>
  <x>773</x>
  <y>517</y>
  <width>43</width>
  <height>29</height>
  <uuid>{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>696.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBController" version="2">
  <objectName>hor43</objectName>
  <x>825</x>
  <y>547</y>
  <width>20</width>
  <height>150</height>
  <uuid>{e504cab2-fd65-442e-988f-0fd968f8cab8}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <objectName2>f0res16</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>100.00000000</yMin>
  <yMax>15000.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>1788.66662598</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>f0res16</objectName>
  <x>817</x>
  <y>517</y>
  <width>42</width>
  <height>29</height>
  <uuid>{10b21f58-bdaf-49eb-a574-f732898fa8a4}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>1788.667</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Britannic Bold</font>
  <fontsize>8</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>dur</objectName>
  <x>1315</x>
  <y>620</y>
  <width>32</width>
  <height>104</height>
  <uuid>{43502468-8c8c-46ca-8860-9f9058bee7ba}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00100000</minimum>
  <maximum>4.00000000</maximum>
  <value>4.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>1280</x>
  <y>723</y>
  <width>100</width>
  <height>46</height>
  <uuid>{f594ac87-291f-4386-97f5-93966b155b3a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>dur</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>30</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>dur</objectName>
  <x>1310</x>
  <y>591</y>
  <width>44</width>
  <height>28</height>
  <uuid>{9e767756-7162-485e-9d0d-74645a32c5ec}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>4.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>5</x>
  <y>795</y>
  <width>363</width>
  <height>62</height>
  <uuid>{c76b9218-8ce5-4b36-9184-ad41f7887e65}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Railing Synthesis (v.1.1)

</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Lucida Grande</font>
  <fontsize>34</fontsize>
  <precision>3</precision>
  <color>
   <r>237</r>
   <g>59</g>
   <b>58</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>false</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBConsole" version="2">
  <objectName/>
  <x>21</x>
  <y>424</y>
  <width>615</width>
  <height>80</height>
  <uuid>{b52858d4-32af-4d63-b89c-8b294c87f2a6}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <font>Courier</font>
  <fontsize>8</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>Preset1</objectName>
  <x>398</x>
  <y>906</y>
  <width>165</width>
  <height>35</height>
  <uuid>{e9016c23-32cb-4e49-9796-4f759e833b0b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <type>event</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Harmonic Series</text>
  <image>/</image>
  <eventLine>i4 0 0.1</eventLine>
  <latch>false</latch>
  <latched>false</latched>
  <fontsize>10</fontsize>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName/>
  <x>848</x>
  <y>454</y>
  <width>100</width>
  <height>30</height>
  <uuid>{81b9447d-4c7b-4fad-8809-d7b9627b0ebb}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <type>event</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Read Table</text>
  <image>/</image>
  <eventLine>i5 0 0.1</eventLine>
  <latch>false</latch>
  <latched>false</latched>
  <fontsize>10</fontsize>
 </bsbObject>
 <bsbObject type="BSBDropdown" version="2">
  <objectName>tablemenu</objectName>
  <x>861</x>
  <y>428</y>
  <width>80</width>
  <height>30</height>
  <uuid>{41f5ac06-3b49-4566-809d-7a09abfc655e}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <bsbDropdownItemList>
   <bsbDropdownItem>
    <name>Tab1</name>
    <value>0</value>
    <stringvalue/>
   </bsbDropdownItem>
   <bsbDropdownItem>
    <name>Tab2</name>
    <value>1</value>
    <stringvalue/>
   </bsbDropdownItem>
   <bsbDropdownItem>
    <name> Tab3</name>
    <value>2</value>
    <stringvalue/>
   </bsbDropdownItem>
   <bsbDropdownItem>
    <name> Tab4</name>
    <value>3</value>
    <stringvalue/>
   </bsbDropdownItem>
   <bsbDropdownItem>
    <name> Tab5</name>
    <value>4</value>
    <stringvalue/>
   </bsbDropdownItem>
   <bsbDropdownItem>
    <name> Tab6</name>
    <value>5</value>
    <stringvalue/>
   </bsbDropdownItem>
   <bsbDropdownItem>
    <name> Tab7</name>
    <value>6</value>
    <stringvalue/>
   </bsbDropdownItem>
   <bsbDropdownItem>
    <name> Tab8</name>
    <value>7</value>
    <stringvalue/>
   </bsbDropdownItem>
   <bsbDropdownItem>
    <name> Tab9</name>
    <value>8</value>
    <stringvalue/>
   </bsbDropdownItem>
   <bsbDropdownItem>
    <name> Tab10</name>
    <value>9</value>
    <stringvalue/>
   </bsbDropdownItem>
  </bsbDropdownItemList>
  <selectedIndex>1</selectedIndex>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>7</x>
  <y>857</y>
  <width>330</width>
  <height>85</height>
  <uuid>{06ae0099-20b3-4005-9ebf-b8a67fb01958}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Tomasetti Matteo
LEMS - Pesaro - 2017</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Brush Script MT</font>
  <fontsize>40</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>false</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>823</x>
  <y>180</y>
  <width>154</width>
  <height>37</height>
  <uuid>{48cf993d-a0c4-474f-8243-9f31956965f4}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Sounds like Carillon!</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>24</fontsize>
  <precision>3</precision>
  <color>
   <r>237</r>
   <g>59</g>
   <b>58</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>1273</x>
  <y>383</y>
  <width>80</width>
  <height>25</height>
  <uuid>{be7ffe14-a837-4ae6-a87b-01d445681d0f}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>DECAY</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>210</g>
   <b>8</b>
  </color>
  <bgcolor mode="background">
   <r>0</r>
   <g>33</g>
   <b>254</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>1356</x>
  <y>383</y>
  <width>120</width>
  <height>25</height>
  <uuid>{d06a6596-6f0f-4a28-b044-80d31f758de2}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>HIGH FREQUENCIES</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>210</g>
   <b>8</b>
  </color>
  <bgcolor mode="background">
   <r>0</r>
   <g>60</g>
   <b>254</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBKnob" version="2">
  <objectName>dec</objectName>
  <x>1273</x>
  <y>406</y>
  <width>80</width>
  <height>80</height>
  <uuid>{4bbe1673-18da-4fd2-b5c8-ca683b2e3264}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.58000000</value>
  <mode>lin</mode>
  <mouseControl act="">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
  <color>
   <r>245</r>
   <g>124</g>
   <b>0</b>
  </color>
  <textcolor>#512900</textcolor>
  <border>0</border>
  <borderColor>#512900</borderColor>
  <showvalue>true</showvalue>
  <flatstyle>true</flatstyle>
  <integerMode>false</integerMode>
 </bsbObject>
 <bsbObject type="BSBKnob" version="2">
  <objectName>hf</objectName>
  <x>1373</x>
  <y>405</y>
  <width>80</width>
  <height>80</height>
  <uuid>{0997e946-6716-4b3e-9b85-c9d9f2dff660}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.08000000</value>
  <mode>lin</mode>
  <mouseControl act="">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
  <color>
   <r>245</r>
   <g>124</g>
   <b>0</b>
  </color>
  <textcolor>#512900</textcolor>
  <border>0</border>
  <borderColor>#512900</borderColor>
  <showvalue>true</showvalue>
  <flatstyle>true</flatstyle>
  <integerMode>false</integerMode>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>1180</x>
  <y>383</y>
  <width>92</width>
  <height>26</height>
  <uuid>{552a88ec-f92d-4693-ad4a-973274b18513}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>on/off</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>14</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="background">
   <r>0</r>
   <g>12</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBCheckBox" version="2">
  <objectName>mute</objectName>
  <x>1214</x>
  <y>410</y>
  <width>26</width>
  <height>36</height>
  <uuid>{c9e7de4c-fd40-48e8-92fa-82dc416d3db4}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <selected>true</selected>
  <label/>
  <pressedValue>1</pressedValue>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>1180</x>
  <y>332</y>
  <width>295</width>
  <height>49</height>
  <uuid>{9a60132b-8454-4df9-98e3-a1ca0fd7768a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Master Reverb</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Apple Chancery</font>
  <fontsize>40</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="background">
   <r>237</r>
   <g>24</g>
   <b>61</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>Preset2</objectName>
  <x>566</x>
  <y>875</y>
  <width>147</width>
  <height>36</height>
  <uuid>{91ffa259-7ff9-46d2-bbbf-ed0be213a299}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <type>event</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Fibonacci (110 First)</text>
  <image>/</image>
  <eventLine>i27 0 0.1</eventLine>
  <latch>false</latch>
  <latched>false</latched>
  <fontsize>10</fontsize>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>Preset3</objectName>
  <x>566</x>
  <y>840</y>
  <width>147</width>
  <height>37</height>
  <uuid>{652306da-467b-4488-9b99-fba18e1b5c12}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <type>event</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Inharmonic A-Sound</text>
  <image>/</image>
  <eventLine>i28 0 0.1</eventLine>
  <latch>false</latch>
  <latched>false</latched>
  <fontsize>10</fontsize>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>1176</x>
  <y>533</y>
  <width>453</width>
  <height>57</height>
  <uuid>{c5638408-c163-45e0-b947-50e0207daf7a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Master Envelope</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Apple Chancery</font>
  <fontsize>40</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="background">
   <r>237</r>
   <g>24</g>
   <b>61</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>Preset4</objectName>
  <x>398</x>
  <y>873</y>
  <width>164</width>
  <height>33</height>
  <uuid>{452a036d-c30b-4645-9052-1c73b35c16a0}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <type>event</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Pseudo Pi Greco Series</text>
  <image>/</image>
  <eventLine>i36 0 0.1</eventLine>
  <latch>false</latch>
  <latched>false</latched>
  <fontsize>10</fontsize>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>Preset5</objectName>
  <x>399</x>
  <y>841</y>
  <width>163</width>
  <height>33</height>
  <uuid>{02ec4190-bca5-46ba-bc1e-215a1150bacc}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <type>event</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>C (66Hz) Harmonic Series</text>
  <image>/</image>
  <eventLine>i31 0 0.1</eventLine>
  <latch>false</latch>
  <latched>false</latched>
  <fontsize>10</fontsize>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>398</x>
  <y>792</y>
  <width>318</width>
  <height>47</height>
  <uuid>{7095e495-2532-4aba-9df8-3822a8eaef73}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Frequencies Presets</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Apple Chancery</font>
  <fontsize>36</fontsize>
  <precision>3</precision>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <bgcolor mode="background">
   <r>237</r>
   <g>24</g>
   <b>61</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>Preset6</objectName>
  <x>566</x>
  <y>904</y>
  <width>147</width>
  <height>37</height>
  <uuid>{62bf5767-3df9-4e22-9156-64525155ee9b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <type>event</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Inharmonic 2.35 Story</text>
  <image>/</image>
  <eventLine>i31 0 0.1</eventLine>
  <latch>false</latch>
  <latched>false</latched>
  <fontsize>10</fontsize>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>amplitudefm</objectName>
  <x>942</x>
  <y>659</y>
  <width>20</width>
  <height>100</height>
  <uuid>{af2b6524-66ee-4104-95ee-56b04cacc3e4}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>0.01000000</maximum>
  <value>0.00360000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>886</x>
  <y>570</y>
  <width>134</width>
  <height>65</height>
  <uuid>{06a365a9-b1f7-4ed2-94b7-6fc667b2b0e7}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>FM Amplitude</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Lucida Grande</font>
  <fontsize>21</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>false</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>freqmod</objectName>
  <x>1041</x>
  <y>855</y>
  <width>20</width>
  <height>100</height>
  <uuid>{9df4ef51-f3b6-4d4f-9970-ea0fc2b2eb80}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>1.00000000</minimum>
  <maximum>7000.00000000</maximum>
  <value>140.98000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>995</x>
  <y>765</y>
  <width>118</width>
  <height>60</height>
  <uuid>{842760a9-f53b-49b7-b44b-6730930ca895}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Modulator Frequency</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>24</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>975</x>
  <y>572</y>
  <width>158</width>
  <height>63</height>
  <uuid>{a8572b33-1bbe-4fe4-8e64-a927d6caf778}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Modulation Index</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Lucida Grande</font>
  <fontsize>21</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>false</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>indicemod</objectName>
  <x>1036</x>
  <y>659</y>
  <width>20</width>
  <height>100</height>
  <uuid>{3d345656-ff07-48cd-811e-06c67772ffca}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>30.00000000</maximum>
  <value>5.10000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>886</x>
  <y>518</y>
  <width>249</width>
  <height>55</height>
  <uuid>{5250f7e3-83a0-4f01-a12d-6570448ae01c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>FM Controls</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Apple Chancery</font>
  <fontsize>40</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>71</r>
   <g>219</g>
   <b>237</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject type="BSBScrollNumber" version="2">
  <objectName>amplitudefm</objectName>
  <x>927</x>
  <y>634</y>
  <width>53</width>
  <height>24</height>
  <uuid>{96145f79-885f-4cb1-a54d-eb1e7ec2dd3b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <value>0.00360000</value>
  <resolution>0.00100000</resolution>
  <minimum>-999999999999.00000000</minimum>
  <maximum>999999999999.00000000</maximum>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
  <randomizable group="0">false</randomizable>
  <mouseControl act=""/>
 </bsbObject>
 <bsbObject type="BSBScrollNumber" version="2">
  <objectName>indicemod</objectName>
  <x>1019</x>
  <y>634</y>
  <width>53</width>
  <height>24</height>
  <uuid>{7a4e474d-d6df-4577-a499-1e633ee7bdd9}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <value>5.10000000</value>
  <resolution>0.00100000</resolution>
  <minimum>-999999999999.00000000</minimum>
  <maximum>999999999999.00000000</maximum>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
  <randomizable group="0">false</randomizable>
  <mouseControl act=""/>
 </bsbObject>
 <bsbObject type="BSBScrollNumber" version="2">
  <objectName>freqmod</objectName>
  <x>1032</x>
  <y>831</y>
  <width>53</width>
  <height>24</height>
  <uuid>{c1e481b6-e064-4d2d-af57-560d5c065070}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <value>140.98000000</value>
  <resolution>0.00100000</resolution>
  <minimum>-999999999999.00000000</minimum>
  <maximum>999999999999.00000000</maximum>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
  <randomizable group="0">false</randomizable>
  <mouseControl act=""/>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>portante</objectName>
  <x>948</x>
  <y>856</y>
  <width>20</width>
  <height>100</height>
  <uuid>{303dac5c-b602-4e53-954b-545b1b9a24ff}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>7000.00000000</maximum>
  <value>700.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBScrollNumber" version="2">
  <objectName>portante</objectName>
  <x>934</x>
  <y>830</y>
  <width>53</width>
  <height>24</height>
  <uuid>{fd4f540f-4016-4613-a2a5-c36abdacb491}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <value>700.00000000</value>
  <resolution>0.00100000</resolution>
  <minimum>-999999999999.00000000</minimum>
  <maximum>999999999999.00000000</maximum>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
  <randomizable group="0">false</randomizable>
  <mouseControl act=""/>
 </bsbObject>
 <bsbObject type="BSBLabel" version="2">
  <objectName/>
  <x>909</x>
  <y>786</y>
  <width>85</width>
  <height>32</height>
  <uuid>{48b2cbb4-677e-4f66-9515-b49853fefdea}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Carrier</label>
  <alignment>center</alignment>
  <valignment>top</valignment>
  <font>Broadway Copyist Text</font>
  <fontsize>24</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
</bsbPanel>
<bsbPresets>
<preset name="BeLL SounD (Campanone)" number="1" >
<value id="{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}" mode="1" >1.00000000</value>
<value id="{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}" mode="1" >0.56000000</value>
<value id="{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}" mode="1" >0.69999999</value>
<value id="{374dbca9-a526-4d0e-b5e3-90478049b6bf}" mode="1" >0.43000001</value>
<value id="{056dbef4-8826-4d69-8e6a-852c4edc2ea8}" mode="1" >0.62000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="4" >0</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="4" >0</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="4" >0</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="4" >0</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="4" >0</value>
<value id="{34836809-f2ae-40bf-83f4-70afd41e31d5}" mode="1" >1.00000000</value>
<value id="{1feef608-a361-4450-ab55-7696af9b3ae4}" mode="1" >1.37000000</value>
<value id="{c78a7996-cc03-400d-b5c3-0345e930d720}" mode="1" >12000.00000000</value>
<value id="{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}" mode="1" >1387.00000000</value>
<value id="{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}" mode="1" >76.98999786</value>
<value id="{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}" mode="1" >1.00000000</value>
<value id="{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}" mode="4" >0</value>
<value id="{3dbe21c8-d134-48a2-a35d-06b231b2d800}" mode="1" >-255.00000000</value>
<value id="{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}" mode="1" >0.00000000</value>
<value id="{1fba5c43-d60e-49dc-8e1f-34467529754f}" mode="1" >1.41100001</value>
<value id="{57e07eec-f065-407f-bc8b-652ff42dd6da}" mode="1" >3.00000000</value>
<value id="{f4be3e35-886e-4424-96f9-a8caee28dace}" mode="1" >0.00000000</value>
<value id="{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}" mode="1" >0.00000000</value>
<value id="{e9d00afa-2d17-4143-aae7-0a9add2429a8}" mode="1" >0.00000000</value>
<value id="{f63e36a9-4510-4b12-bd82-62fa0686ba4f}" mode="1" >76.98999786</value>
<value id="{48dcad2d-eb3e-42a7-9793-ed2e19355426}" mode="1" >1387.00000000</value>
<value id="{6f061ce3-ab4b-4e1a-853f-42e97952075c}" mode="1" >646.00000000</value>
<value id="{52f30728-cf31-43c5-abd5-9968e6f45bae}" mode="1" >3.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="1" >0.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="2" >0.33846155</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="1" >0.00000000</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="2" >0.36923078</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="1" >0.00000000</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="2" >0.60769230</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="1" >0.00000000</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="2" >0.33846155</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="1" >0.00000000</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="2" >0.90769231</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="1" >0.00000000</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="2" >0.68461537</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="1" >0.00000000</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="2" >0.49230769</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="1" >0.00000000</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="2" >0.85384613</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="1" >0.00000000</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="2" >0.33846155</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="1" >0.00000000</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="2" >0.57692307</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="1" >0.00000000</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="2" >1.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="1" >0.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="2" >0.72307694</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="1" >0.00000000</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="2" >0.79230767</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="1" >0.00000000</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="2" >0.96923077</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="1" >0.00000000</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="2" >568.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="1" >0.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="2" >2232.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="1" >0.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="2" >1634.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="1" >0.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="2" >1192.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="1" >0.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="2" >3610.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="1" >0.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="2" >412.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="1" >0.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="2" >854.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="1" >0.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="2" >3818.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="1" >0.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="2" >2700.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="1" >0.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="2" >490.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="1" >0.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="2" >3558.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="1" >0.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="2" >3532.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="1" >3558.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="4" >3558.000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="1" >568.00000000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="4" >568.000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="1" >2232.00000000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="4" >2232.000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="1" >1634.00000000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="4" >1634.000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="1" >1192.00000000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="4" >1192.000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="1" >3610.00000000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="4" >3610.000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="1" >412.00000000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="4" >412.000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="1" >854.00000000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="4" >854.000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="1" >3818.00000000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="4" >3818.000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="1" >2700.00000000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="4" >2700.000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="1" >490.00000000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="4" >490.000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="1" >3532.00000000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="4" >3532.000</value>
</preset>
<preset name="RailingChurch" number="4" >
<value id="{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}" mode="1" >0.66000003</value>
<value id="{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}" mode="1" >0.69000000</value>
<value id="{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}" mode="1" >0.40000001</value>
<value id="{374dbca9-a526-4d0e-b5e3-90478049b6bf}" mode="1" >0.77999997</value>
<value id="{056dbef4-8826-4d69-8e6a-852c4edc2ea8}" mode="1" >0.58999997</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="1" >0.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="4" >0</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="1" >0.00000000</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="4" >0</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="1" >0.00000000</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="4" >0</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="1" >0.00000000</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="4" >0</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="1" >0.00000000</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="4" >0</value>
<value id="{34836809-f2ae-40bf-83f4-70afd41e31d5}" mode="1" >0.74000001</value>
<value id="{1feef608-a361-4450-ab55-7696af9b3ae4}" mode="1" >2.00000000</value>
<value id="{c78a7996-cc03-400d-b5c3-0345e930d720}" mode="1" >8311.00000000</value>
<value id="{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}" mode="1" >1387.00000000</value>
<value id="{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}" mode="1" >96.36000061</value>
<value id="{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}" mode="1" >1.00000000</value>
<value id="{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}" mode="4" >0</value>
<value id="{3dbe21c8-d134-48a2-a35d-06b231b2d800}" mode="1" >-255.00000000</value>
<value id="{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}" mode="1" >0.00000000</value>
<value id="{1fba5c43-d60e-49dc-8e1f-34467529754f}" mode="1" >3.00000000</value>
<value id="{57e07eec-f065-407f-bc8b-652ff42dd6da}" mode="1" >0.50000000</value>
<value id="{f4be3e35-886e-4424-96f9-a8caee28dace}" mode="1" >0.00000000</value>
<value id="{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}" mode="1" >0.00000000</value>
<value id="{e9d00afa-2d17-4143-aae7-0a9add2429a8}" mode="1" >415.00018311</value>
<value id="{f63e36a9-4510-4b12-bd82-62fa0686ba4f}" mode="1" >56.13000107</value>
<value id="{48dcad2d-eb3e-42a7-9793-ed2e19355426}" mode="1" >1387.00000000</value>
<value id="{6f061ce3-ab4b-4e1a-853f-42e97952075c}" mode="1" >8311.00000000</value>
<value id="{52f30728-cf31-43c5-abd5-9968e6f45bae}" mode="1" >0.50000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="1" >0.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="2" >0.88461536</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="1" >0.00000000</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="2" >0.57692307</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="1" >0.00000000</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="2" >0.33076924</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="1" >0.00000000</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="2" >0.88461536</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="1" >0.00000000</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="2" >0.43076923</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="1" >0.00000000</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="2" >0.55384612</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="1" >0.00000000</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="2" >0.41538462</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="1" >0.00000000</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="2" >0.53076923</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="1" >0.00000000</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="2" >0.88461536</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="1" >0.00000000</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="2" >0.69999999</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="1" >0.00000000</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="2" >0.48461539</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="1" >0.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="2" >0.74615383</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="1" >0.00000000</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="2" >0.89230770</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="1" >0.00000000</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="2" >0.33076924</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="1" >0.00000000</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="2" >386.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="1" >0.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="2" >412.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="1" >0.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="2" >620.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="1" >0.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="2" >178.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="1" >0.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="2" >308.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="1" >0.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="2" >308.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="1" >0.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="2" >516.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="1" >0.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="2" >256.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="1" >0.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="2" >542.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="1" >0.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="2" >464.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="1" >0.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="2" >750.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="1" >0.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="2" >308.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="1" >750.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="4" >750.000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="1" >386.00000000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="4" >386.000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="1" >412.00000000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="4" >412.000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="1" >620.00000000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="4" >620.000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="1" >178.00000000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="4" >178.000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="1" >308.00000000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="4" >308.000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="1" >308.00000000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="4" >308.000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="1" >516.00000000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="4" >516.000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="1" >256.00000000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="4" >256.000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="1" >542.00000000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="4" >542.000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="1" >464.00000000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="4" >464.000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="1" >308.00000000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="4" >308.000</value>
<value id="{bf83e1da-fb92-4782-b291-79f2fadbc31b}" mode="1" >0.00100000</value>
<value id="{b29455b4-1f35-4da7-b6e3-1d26749f211b}" mode="1" >0.12088000</value>
<value id="{019ab94d-9192-4b84-9baa-480b3d8a287a}" mode="1" >1.15999997</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="1" >0.00100000</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="4" >0.001</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="1" >0.12100000</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="4" >0.121</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="1" >1.15999997</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="4" >1.160</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="1" >0.00000000</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="2" >0.55384618</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="1" >0.00000000</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="2" >0.46153846</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="1" >0.00000000</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="2" >0.23846154</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="1" >0.00000000</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="2" >0.23846154</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="1" >0.00000000</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="2" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="1" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="4" >1292.000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="1" >0.00000000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="2" >795.33331299</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="1" >795.33300781</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="4" >795.333</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="1" >0.00000000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="2" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="1" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="4" >696.000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="1" >0.00000000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="2" >1788.66662598</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="1" >1788.66662598</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="4" >1788.667</value>
<value id="{43502468-8c8c-46ca-8860-9f9058bee7ba}" mode="1" >1.92051995</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="1" >1.92100000</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="4" >1.921</value>
<value id="{e9016c23-32cb-4e49-9796-4f759e833b0b}" mode="4" >0</value>
<value id="{81b9447d-4c7b-4fad-8809-d7b9627b0ebb}" mode="4" >0</value>
<value id="{41f5ac06-3b49-4566-809d-7a09abfc655e}" mode="1" >1.00000000</value>
<value id="{4bbe1673-18da-4fd2-b5c8-ca683b2e3264}" mode="1" >0.88999999</value>
<value id="{0997e946-6716-4b3e-9b85-c9d9f2dff660}" mode="1" >0.10000000</value>
<value id="{c9e7de4c-fd40-48e8-92fa-82dc416d3db4}" mode="1" >1.00000000</value>
</preset>
<preset name="Far-Pulses" number="0" >
<value id="{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}" mode="1" >0.66000003</value>
<value id="{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}" mode="1" >0.69000000</value>
<value id="{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}" mode="1" >0.40000001</value>
<value id="{374dbca9-a526-4d0e-b5e3-90478049b6bf}" mode="1" >0.77999997</value>
<value id="{056dbef4-8826-4d69-8e6a-852c4edc2ea8}" mode="1" >0.58999997</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="1" >0.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="4" >0</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="1" >0.00000000</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="4" >0</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="1" >0.00000000</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="4" >0</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="1" >0.00000000</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="4" >0</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="1" >0.00000000</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="4" >0</value>
<value id="{34836809-f2ae-40bf-83f4-70afd41e31d5}" mode="1" >0.74000001</value>
<value id="{1feef608-a361-4450-ab55-7696af9b3ae4}" mode="1" >2.00000000</value>
<value id="{c78a7996-cc03-400d-b5c3-0345e930d720}" mode="1" >8311.00000000</value>
<value id="{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}" mode="1" >1387.00000000</value>
<value id="{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}" mode="1" >96.36000061</value>
<value id="{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}" mode="1" >1.00000000</value>
<value id="{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}" mode="4" >0</value>
<value id="{3dbe21c8-d134-48a2-a35d-06b231b2d800}" mode="1" >-255.00000000</value>
<value id="{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}" mode="1" >0.00000000</value>
<value id="{1fba5c43-d60e-49dc-8e1f-34467529754f}" mode="1" >3.00000000</value>
<value id="{57e07eec-f065-407f-bc8b-652ff42dd6da}" mode="1" >21.78499985</value>
<value id="{f4be3e35-886e-4424-96f9-a8caee28dace}" mode="1" >0.00000000</value>
<value id="{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}" mode="1" >0.00000000</value>
<value id="{e9d00afa-2d17-4143-aae7-0a9add2429a8}" mode="1" >415.00018311</value>
<value id="{f63e36a9-4510-4b12-bd82-62fa0686ba4f}" mode="1" >56.13000107</value>
<value id="{48dcad2d-eb3e-42a7-9793-ed2e19355426}" mode="1" >1387.00000000</value>
<value id="{6f061ce3-ab4b-4e1a-853f-42e97952075c}" mode="1" >8311.00000000</value>
<value id="{52f30728-cf31-43c5-abd5-9968e6f45bae}" mode="1" >21.78499985</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="1" >0.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="2" >0.88461536</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="1" >0.00000000</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="2" >0.57692307</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="1" >0.00000000</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="2" >0.33076924</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="1" >0.00000000</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="2" >0.88461536</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="1" >0.00000000</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="2" >0.43076923</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="1" >0.00000000</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="2" >0.55384612</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="1" >0.00000000</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="2" >0.41538462</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="1" >0.00000000</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="2" >0.53076923</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="1" >0.00000000</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="2" >0.88461536</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="1" >0.00000000</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="2" >0.69999999</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="1" >0.00000000</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="2" >0.48461539</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="1" >0.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="2" >0.74615383</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="1" >0.00000000</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="2" >0.89230770</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="1" >0.00000000</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="2" >0.33076924</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="1" >0.00000000</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="2" >1062.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="1" >0.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="2" >880.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="1" >0.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="2" >932.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="1" >0.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="2" >178.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="1" >0.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="2" >308.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="1" >0.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="2" >308.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="1" >0.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="2" >516.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="1" >0.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="2" >256.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="1" >0.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="2" >542.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="1" >0.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="2" >464.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="1" >0.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="2" >984.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="1" >0.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="2" >308.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="1" >984.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="4" >984.000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="1" >1062.00000000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="4" >1062.000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="1" >880.00000000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="4" >880.000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="1" >932.00000000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="4" >932.000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="1" >178.00000000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="4" >178.000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="1" >308.00000000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="4" >308.000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="1" >308.00000000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="4" >308.000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="1" >516.00000000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="4" >516.000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="1" >256.00000000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="4" >256.000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="1" >542.00000000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="4" >542.000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="1" >464.00000000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="4" >464.000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="1" >308.00000000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="4" >308.000</value>
<value id="{bf83e1da-fb92-4782-b291-79f2fadbc31b}" mode="1" >0.00100000</value>
<value id="{b29455b4-1f35-4da7-b6e3-1d26749f211b}" mode="1" >0.12088000</value>
<value id="{019ab94d-9192-4b84-9baa-480b3d8a287a}" mode="1" >1.15999997</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="1" >0.00100000</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="4" >0.001</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="1" >0.12100000</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="4" >0.121</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="1" >1.15999997</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="4" >1.160</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="1" >0.00000000</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="2" >0.55384618</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="1" >0.00000000</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="2" >0.46153846</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="1" >0.00000000</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="2" >0.23846154</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="1" >0.00000000</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="2" >0.23846154</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="1" >0.00000000</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="2" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="1" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="4" >1292.000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="1" >0.00000000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="2" >795.33331299</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="1" >795.33300781</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="4" >795.333</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="1" >0.00000000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="2" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="1" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="4" >696.000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="1" >0.00000000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="2" >1788.66662598</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="1" >1788.66662598</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="4" >1788.667</value>
<value id="{43502468-8c8c-46ca-8860-9f9058bee7ba}" mode="1" >1.92051995</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="1" >1.92100000</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="4" >1.921</value>
<value id="{e9016c23-32cb-4e49-9796-4f759e833b0b}" mode="4" >0</value>
<value id="{81b9447d-4c7b-4fad-8809-d7b9627b0ebb}" mode="4" >0</value>
<value id="{41f5ac06-3b49-4566-809d-7a09abfc655e}" mode="1" >1.00000000</value>
<value id="{4bbe1673-18da-4fd2-b5c8-ca683b2e3264}" mode="1" >0.88999999</value>
<value id="{0997e946-6716-4b3e-9b85-c9d9f2dff660}" mode="1" >0.10000000</value>
<value id="{c9e7de4c-fd40-48e8-92fa-82dc416d3db4}" mode="1" >1.00000000</value>
</preset>
<preset name="BeLLs" number="2" >
<value id="{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}" mode="1" >0.66000003</value>
<value id="{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}" mode="1" >0.69000000</value>
<value id="{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}" mode="1" >0.40000001</value>
<value id="{374dbca9-a526-4d0e-b5e3-90478049b6bf}" mode="1" >0.77999997</value>
<value id="{056dbef4-8826-4d69-8e6a-852c4edc2ea8}" mode="1" >0.58999997</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="1" >0.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="4" >0</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="1" >0.00000000</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="4" >0</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="1" >0.00000000</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="4" >0</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="1" >0.00000000</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="4" >0</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="1" >0.00000000</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="4" >0</value>
<value id="{34836809-f2ae-40bf-83f4-70afd41e31d5}" mode="1" >0.74000001</value>
<value id="{1feef608-a361-4450-ab55-7696af9b3ae4}" mode="1" >2.00000000</value>
<value id="{c78a7996-cc03-400d-b5c3-0345e930d720}" mode="1" >8311.00000000</value>
<value id="{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}" mode="1" >1387.00000000</value>
<value id="{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}" mode="1" >96.36000061</value>
<value id="{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}" mode="1" >1.00000000</value>
<value id="{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}" mode="4" >0</value>
<value id="{3dbe21c8-d134-48a2-a35d-06b231b2d800}" mode="1" >-255.00000000</value>
<value id="{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}" mode="1" >0.00000000</value>
<value id="{1fba5c43-d60e-49dc-8e1f-34467529754f}" mode="1" >3.00000000</value>
<value id="{57e07eec-f065-407f-bc8b-652ff42dd6da}" mode="1" >0.50000000</value>
<value id="{f4be3e35-886e-4424-96f9-a8caee28dace}" mode="1" >0.00000000</value>
<value id="{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}" mode="1" >0.00000000</value>
<value id="{e9d00afa-2d17-4143-aae7-0a9add2429a8}" mode="1" >415.00018311</value>
<value id="{f63e36a9-4510-4b12-bd82-62fa0686ba4f}" mode="1" >56.13000107</value>
<value id="{48dcad2d-eb3e-42a7-9793-ed2e19355426}" mode="1" >1387.00000000</value>
<value id="{6f061ce3-ab4b-4e1a-853f-42e97952075c}" mode="1" >8311.00000000</value>
<value id="{52f30728-cf31-43c5-abd5-9968e6f45bae}" mode="1" >0.50000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="1" >0.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="2" >0.88461536</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="1" >0.00000000</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="2" >0.57692307</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="1" >0.00000000</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="2" >0.33076924</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="1" >0.00000000</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="2" >0.88461536</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="1" >0.00000000</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="2" >0.43076923</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="1" >0.00000000</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="2" >0.55384612</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="1" >0.00000000</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="2" >0.41538462</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="1" >0.00000000</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="2" >0.53076923</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="1" >0.00000000</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="2" >0.88461536</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="1" >0.00000000</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="2" >0.69999999</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="1" >0.00000000</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="2" >0.48461539</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="1" >0.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="2" >0.74615383</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="1" >0.00000000</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="2" >0.89230770</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="1" >0.00000000</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="2" >0.33076924</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="1" >0.00000000</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="2" >1062.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="1" >0.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="2" >880.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="1" >0.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="2" >932.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="1" >0.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="2" >178.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="1" >0.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="2" >308.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="1" >0.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="2" >308.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="1" >0.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="2" >516.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="1" >0.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="2" >256.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="1" >0.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="2" >542.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="1" >0.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="2" >464.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="1" >0.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="2" >984.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="1" >0.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="2" >308.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="1" >984.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="4" >984.000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="1" >1062.00000000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="4" >1062.000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="1" >880.00000000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="4" >880.000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="1" >932.00000000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="4" >932.000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="1" >178.00000000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="4" >178.000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="1" >308.00000000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="4" >308.000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="1" >308.00000000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="4" >308.000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="1" >516.00000000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="4" >516.000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="1" >256.00000000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="4" >256.000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="1" >542.00000000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="4" >542.000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="1" >464.00000000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="4" >464.000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="1" >308.00000000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="4" >308.000</value>
<value id="{bf83e1da-fb92-4782-b291-79f2fadbc31b}" mode="1" >0.00100000</value>
<value id="{b29455b4-1f35-4da7-b6e3-1d26749f211b}" mode="1" >0.12088000</value>
<value id="{019ab94d-9192-4b84-9baa-480b3d8a287a}" mode="1" >1.15999997</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="1" >0.00100000</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="4" >0.001</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="1" >0.12100000</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="4" >0.121</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="1" >1.15999997</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="4" >1.160</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="1" >0.00000000</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="2" >0.55384618</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="1" >0.00000000</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="2" >0.46153846</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="1" >0.00000000</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="2" >0.23846154</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="1" >0.00000000</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="2" >0.23846154</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="1" >0.00000000</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="2" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="1" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="4" >1292.000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="1" >0.00000000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="2" >795.33331299</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="1" >795.33300781</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="4" >795.333</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="1" >0.00000000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="2" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="1" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="4" >696.000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="1" >0.00000000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="2" >1788.66662598</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="1" >1788.66662598</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="4" >1788.667</value>
<value id="{43502468-8c8c-46ca-8860-9f9058bee7ba}" mode="1" >1.92051995</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="1" >1.92100000</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="4" >1.921</value>
<value id="{e9016c23-32cb-4e49-9796-4f759e833b0b}" mode="4" >0</value>
<value id="{81b9447d-4c7b-4fad-8809-d7b9627b0ebb}" mode="4" >0</value>
<value id="{41f5ac06-3b49-4566-809d-7a09abfc655e}" mode="1" >1.00000000</value>
<value id="{4bbe1673-18da-4fd2-b5c8-ca683b2e3264}" mode="1" >0.88999999</value>
<value id="{0997e946-6716-4b3e-9b85-c9d9f2dff660}" mode="1" >0.10000000</value>
<value id="{c9e7de4c-fd40-48e8-92fa-82dc416d3db4}" mode="1" >1.00000000</value>
</preset>
<preset name="Echo-Drops" number="3" >
<value id="{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}" mode="1" >0.66000003</value>
<value id="{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}" mode="1" >0.69000000</value>
<value id="{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}" mode="1" >0.40000001</value>
<value id="{374dbca9-a526-4d0e-b5e3-90478049b6bf}" mode="1" >0.77999997</value>
<value id="{056dbef4-8826-4d69-8e6a-852c4edc2ea8}" mode="1" >0.58999997</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="1" >0.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="4" >0</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="1" >0.00000000</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="4" >0</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="1" >0.00000000</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="4" >0</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="1" >0.00000000</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="4" >0</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="1" >0.00000000</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="4" >0</value>
<value id="{34836809-f2ae-40bf-83f4-70afd41e31d5}" mode="1" >1.00000000</value>
<value id="{1feef608-a361-4450-ab55-7696af9b3ae4}" mode="1" >1.04545450</value>
<value id="{c78a7996-cc03-400d-b5c3-0345e930d720}" mode="1" >12000.00000000</value>
<value id="{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}" mode="1" >1690.29125977</value>
<value id="{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}" mode="1" >116.72815704</value>
<value id="{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}" mode="1" >1.00000000</value>
<value id="{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}" mode="4" >0</value>
<value id="{3dbe21c8-d134-48a2-a35d-06b231b2d800}" mode="1" >-255.00000000</value>
<value id="{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}" mode="1" >0.00000000</value>
<value id="{1fba5c43-d60e-49dc-8e1f-34467529754f}" mode="1" >1.89800000</value>
<value id="{57e07eec-f065-407f-bc8b-652ff42dd6da}" mode="1" >41.58499908</value>
<value id="{f4be3e35-886e-4424-96f9-a8caee28dace}" mode="1" >201.00000000</value>
<value id="{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}" mode="1" >201.00000000</value>
<value id="{e9d00afa-2d17-4143-aae7-0a9add2429a8}" mode="1" >215.00056458</value>
<value id="{f63e36a9-4510-4b12-bd82-62fa0686ba4f}" mode="1" >116.72815704</value>
<value id="{48dcad2d-eb3e-42a7-9793-ed2e19355426}" mode="1" >1690.29125977</value>
<value id="{6f061ce3-ab4b-4e1a-853f-42e97952075c}" mode="1" >12000.00000000</value>
<value id="{52f30728-cf31-43c5-abd5-9968e6f45bae}" mode="1" >41.58499908</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="1" >0.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="2" >0.88461536</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="1" >0.00000000</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="2" >0.57692307</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="1" >0.00000000</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="2" >0.33076924</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="1" >0.00000000</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="2" >0.88461536</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="1" >0.00000000</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="2" >0.73846155</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="1" >0.00000000</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="2" >0.55384612</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="1" >0.00000000</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="2" >0.83846152</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="1" >0.00000000</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="2" >0.53076923</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="1" >0.00000000</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="2" >0.88461536</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="1" >0.00000000</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="2" >0.69999999</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="1" >0.00000000</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="2" >0.48461539</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="1" >0.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="2" >0.74615383</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="1" >0.00000000</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="2" >0.89230770</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="1" >0.00000000</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="2" >0.33076924</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="1" >0.00000000</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="2" >1062.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="1" >0.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="2" >880.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="1" >0.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="2" >932.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="1" >0.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="2" >3584.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="1" >0.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="2" >2960.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="1" >0.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="2" >3506.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="1" >0.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="2" >516.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="1" >0.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="2" >256.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="1" >0.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="2" >542.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="1" >0.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="2" >464.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="1" >0.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="2" >984.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="1" >0.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="2" >308.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="1" >984.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="4" >984.000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="1" >1062.00000000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="4" >1062.000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="1" >880.00000000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="4" >880.000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="1" >932.00000000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="4" >932.000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="1" >3584.00000000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="4" >3584.000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="1" >2960.00000000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="4" >2960.000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="1" >3506.00000000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="4" >3506.000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="1" >516.00000000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="4" >516.000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="1" >256.00000000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="4" >256.000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="1" >542.00000000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="4" >542.000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="1" >464.00000000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="4" >464.000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="1" >308.00000000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="4" >308.000</value>
<value id="{bf83e1da-fb92-4782-b291-79f2fadbc31b}" mode="1" >0.00100000</value>
<value id="{b29455b4-1f35-4da7-b6e3-1d26749f211b}" mode="1" >0.12088000</value>
<value id="{019ab94d-9192-4b84-9baa-480b3d8a287a}" mode="1" >1.15999997</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="1" >0.00100000</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="4" >0.001</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="1" >0.12100000</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="4" >0.121</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="1" >1.15999997</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="4" >1.160</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="1" >0.00000000</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="2" >0.55384618</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="1" >0.00000000</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="2" >0.46153846</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="1" >0.00000000</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="2" >0.23846154</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="1" >0.00000000</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="2" >0.23846154</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="1" >0.00000000</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="2" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="1" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="4" >1292.000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="1" >0.00000000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="2" >795.33331299</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="1" >795.33300781</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="4" >795.333</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="1" >0.00000000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="2" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="1" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="4" >696.000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="1" >0.00000000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="2" >1788.66662598</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="1" >1788.66662598</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="4" >1788.667</value>
<value id="{43502468-8c8c-46ca-8860-9f9058bee7ba}" mode="1" >1.92051995</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="1" >1.92100000</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="4" >1.921</value>
<value id="{e9016c23-32cb-4e49-9796-4f759e833b0b}" mode="4" >0</value>
<value id="{81b9447d-4c7b-4fad-8809-d7b9627b0ebb}" mode="4" >0</value>
<value id="{41f5ac06-3b49-4566-809d-7a09abfc655e}" mode="1" >1.00000000</value>
<value id="{4bbe1673-18da-4fd2-b5c8-ca683b2e3264}" mode="1" >0.75999999</value>
<value id="{0997e946-6716-4b3e-9b85-c9d9f2dff660}" mode="1" >0.43000001</value>
<value id="{c9e7de4c-fd40-48e8-92fa-82dc416d3db4}" mode="1" >1.00000000</value>
</preset>
<preset name="BeLLS #02" number="5" >
<value id="{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}" mode="1" >0.66000003</value>
<value id="{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}" mode="1" >0.69000000</value>
<value id="{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}" mode="1" >0.40000001</value>
<value id="{374dbca9-a526-4d0e-b5e3-90478049b6bf}" mode="1" >0.77999997</value>
<value id="{056dbef4-8826-4d69-8e6a-852c4edc2ea8}" mode="1" >0.58999997</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="1" >0.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="4" >0</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="1" >0.00000000</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="4" >0</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="1" >0.00000000</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="4" >0</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="1" >0.00000000</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="4" >0</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="1" >0.00000000</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="4" >0</value>
<value id="{34836809-f2ae-40bf-83f4-70afd41e31d5}" mode="1" >0.74000001</value>
<value id="{1feef608-a361-4450-ab55-7696af9b3ae4}" mode="1" >2.00000000</value>
<value id="{c78a7996-cc03-400d-b5c3-0345e930d720}" mode="1" >8311.00000000</value>
<value id="{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}" mode="1" >1387.00000000</value>
<value id="{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}" mode="1" >96.36000061</value>
<value id="{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}" mode="1" >1.00000000</value>
<value id="{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}" mode="4" >0</value>
<value id="{3dbe21c8-d134-48a2-a35d-06b231b2d800}" mode="1" >-255.00000000</value>
<value id="{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}" mode="1" >0.00000000</value>
<value id="{1fba5c43-d60e-49dc-8e1f-34467529754f}" mode="1" >3.00000000</value>
<value id="{57e07eec-f065-407f-bc8b-652ff42dd6da}" mode="1" >0.50000000</value>
<value id="{f4be3e35-886e-4424-96f9-a8caee28dace}" mode="1" >0.00000000</value>
<value id="{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}" mode="1" >0.00000000</value>
<value id="{e9d00afa-2d17-4143-aae7-0a9add2429a8}" mode="1" >210.00057983</value>
<value id="{f63e36a9-4510-4b12-bd82-62fa0686ba4f}" mode="1" >56.13000107</value>
<value id="{48dcad2d-eb3e-42a7-9793-ed2e19355426}" mode="1" >1387.00000000</value>
<value id="{6f061ce3-ab4b-4e1a-853f-42e97952075c}" mode="1" >8311.00000000</value>
<value id="{52f30728-cf31-43c5-abd5-9968e6f45bae}" mode="1" >0.50000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="1" >0.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="2" >0.93846154</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="1" >0.00000000</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="2" >0.12307692</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="1" >0.00000000</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="2" >0.33076924</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="1" >0.00000000</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="2" >0.93846154</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="1" >0.00000000</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="2" >0.43076923</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="1" >0.00000000</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="2" >0.55384612</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="1" >0.00000000</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="2" >0.41538462</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="1" >0.00000000</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="2" >0.53076923</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="1" >0.00000000</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="2" >0.93846154</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="1" >0.00000000</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="2" >0.69999999</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="1" >0.00000000</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="2" >0.48461539</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="1" >0.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="2" >0.74615383</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="1" >0.00000000</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="2" >0.89230770</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="1" >0.00000000</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="2" >0.33076924</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="1" >0.00000000</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="2" >256.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="1" >0.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="2" >308.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="1" >0.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="2" >490.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="1" >0.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="2" >178.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="1" >0.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="2" >308.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="1" >0.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="2" >308.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="1" >0.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="2" >516.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="1" >0.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="2" >256.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="1" >0.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="2" >542.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="1" >0.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="2" >464.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="1" >0.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="2" >516.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="1" >0.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="2" >308.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="1" >516.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="4" >516.000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="1" >256.00000000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="4" >256.000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="1" >308.00000000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="4" >308.000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="1" >490.00000000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="4" >490.000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="1" >178.00000000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="4" >178.000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="1" >308.00000000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="4" >308.000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="1" >308.00000000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="4" >308.000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="1" >516.00000000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="4" >516.000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="1" >256.00000000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="4" >256.000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="1" >542.00000000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="4" >542.000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="1" >464.00000000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="4" >464.000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="1" >308.00000000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="4" >308.000</value>
<value id="{bf83e1da-fb92-4782-b291-79f2fadbc31b}" mode="1" >0.00100000</value>
<value id="{b29455b4-1f35-4da7-b6e3-1d26749f211b}" mode="1" >0.76024002</value>
<value id="{019ab94d-9192-4b84-9baa-480b3d8a287a}" mode="1" >1.15999997</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="1" >0.00100000</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="4" >0.001</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="1" >0.76024002</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="4" >0.760</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="1" >1.15999997</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="4" >1.160</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="1" >0.00000000</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="2" >0.05384615</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="1" >0.00000000</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="2" >0.14615385</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="1" >0.00000000</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="2" >0.23846154</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="1" >0.00000000</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="2" >0.23846154</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="1" >0.00000000</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="2" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="1" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="4" >1292.000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="1" >0.00000000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="2" >795.33331299</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="1" >795.33300781</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="4" >795.333</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="1" >0.00000000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="2" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="1" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="4" >696.000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="1" >0.00000000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="2" >1788.66662598</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="1" >1788.66699219</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="4" >1788.667</value>
<value id="{43502468-8c8c-46ca-8860-9f9058bee7ba}" mode="1" >2.96025991</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="1" >2.96025991</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="4" >2.960</value>
<value id="{e9016c23-32cb-4e49-9796-4f759e833b0b}" mode="4" >0</value>
<value id="{81b9447d-4c7b-4fad-8809-d7b9627b0ebb}" mode="4" >0</value>
<value id="{41f5ac06-3b49-4566-809d-7a09abfc655e}" mode="1" >1.00000000</value>
<value id="{4bbe1673-18da-4fd2-b5c8-ca683b2e3264}" mode="1" >0.88999999</value>
<value id="{0997e946-6716-4b3e-9b85-c9d9f2dff660}" mode="1" >0.87000000</value>
<value id="{c9e7de4c-fd40-48e8-92fa-82dc416d3db4}" mode="1" >1.00000000</value>
</preset>
<preset name="Railing Sound #01" number="6" >
<value id="{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}" mode="1" >0.90909094</value>
<value id="{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}" mode="1" >0.21818182</value>
<value id="{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}" mode="1" >0.83636361</value>
<value id="{374dbca9-a526-4d0e-b5e3-90478049b6bf}" mode="1" >0.77999997</value>
<value id="{056dbef4-8826-4d69-8e6a-852c4edc2ea8}" mode="1" >1.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="1" >0.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="4" >0</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="1" >0.00000000</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="4" >0</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="1" >0.00000000</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="4" >0</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="1" >0.00000000</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="4" >0</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="1" >0.00000000</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="4" >0</value>
<value id="{34836809-f2ae-40bf-83f4-70afd41e31d5}" mode="1" >0.74000001</value>
<value id="{1feef608-a361-4450-ab55-7696af9b3ae4}" mode="1" >2.00000000</value>
<value id="{c78a7996-cc03-400d-b5c3-0345e930d720}" mode="1" >8311.00000000</value>
<value id="{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}" mode="1" >4000.00000000</value>
<value id="{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}" mode="1" >96.36000061</value>
<value id="{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}" mode="1" >1.00000000</value>
<value id="{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}" mode="4" >0</value>
<value id="{3dbe21c8-d134-48a2-a35d-06b231b2d800}" mode="1" >-255.00000000</value>
<value id="{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}" mode="1" >0.00000000</value>
<value id="{1fba5c43-d60e-49dc-8e1f-34467529754f}" mode="1" >3.00000000</value>
<value id="{57e07eec-f065-407f-bc8b-652ff42dd6da}" mode="1" >0.50000000</value>
<value id="{f4be3e35-886e-4424-96f9-a8caee28dace}" mode="1" >0.00000000</value>
<value id="{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}" mode="1" >0.00000000</value>
<value id="{e9d00afa-2d17-4143-aae7-0a9add2429a8}" mode="1" >210.00057983</value>
<value id="{f63e36a9-4510-4b12-bd82-62fa0686ba4f}" mode="1" >56.13000107</value>
<value id="{48dcad2d-eb3e-42a7-9793-ed2e19355426}" mode="1" >4000.00000000</value>
<value id="{6f061ce3-ab4b-4e1a-853f-42e97952075c}" mode="1" >8311.00000000</value>
<value id="{52f30728-cf31-43c5-abd5-9968e6f45bae}" mode="1" >0.50000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="1" >0.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="2" >0.93846154</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="1" >0.00000000</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="2" >0.70769233</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="1" >0.00000000</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="2" >0.33076924</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="1" >0.00000000</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="2" >0.93846154</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="1" >0.00000000</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="2" >0.43076923</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="1" >0.00000000</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="2" >0.55384612</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="1" >0.00000000</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="2" >0.41538462</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="1" >0.00000000</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="2" >0.53076923</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="1" >0.00000000</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="2" >0.93846154</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="1" >0.00000000</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="2" >0.69999999</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="1" >0.00000000</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="2" >0.48461539</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="1" >0.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="2" >0.74615383</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="1" >0.00000000</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="2" >0.36153847</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="1" >0.00000000</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="2" >0.33076924</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="1" >0.00000000</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="2" >256.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="1" >0.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="2" >1556.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="1" >0.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="2" >1270.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="1" >0.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="2" >2466.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="1" >0.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="2" >1400.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="1" >0.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="2" >308.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="1" >0.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="2" >516.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="1" >0.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="2" >256.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="1" >0.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="2" >542.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="1" >0.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="2" >464.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="1" >0.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="2" >516.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="1" >0.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="2" >308.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="1" >516.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="4" >516.000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="1" >256.00000000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="4" >256.000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="1" >1556.00000000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="4" >1556.000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="1" >1270.00000000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="4" >1270.000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="1" >2466.00000000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="4" >2466.000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="1" >1400.00000000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="4" >1400.000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="1" >308.00000000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="4" >308.000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="1" >516.00000000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="4" >516.000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="1" >256.00000000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="4" >256.000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="1" >542.00000000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="4" >542.000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="1" >464.00000000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="4" >464.000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="1" >308.00000000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="4" >308.000</value>
<value id="{bf83e1da-fb92-4782-b291-79f2fadbc31b}" mode="1" >0.00100000</value>
<value id="{b29455b4-1f35-4da7-b6e3-1d26749f211b}" mode="1" >0.76024002</value>
<value id="{019ab94d-9192-4b84-9baa-480b3d8a287a}" mode="1" >1.15999997</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="1" >0.00100000</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="4" >0.001</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="1" >0.76024002</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="4" >0.760</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="1" >1.15999997</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="4" >1.160</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="1" >0.00000000</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="2" >0.63076925</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="1" >0.00000000</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="2" >0.14615385</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="1" >0.00000000</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="2" >0.23846154</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="1" >0.00000000</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="2" >0.23846154</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="1" >0.00000000</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="2" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="1" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="4" >1292.000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="1" >0.00000000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="2" >795.33331299</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="1" >795.33300781</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="4" >795.333</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="1" >0.00000000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="2" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="1" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="4" >696.000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="1" >0.00000000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="2" >1788.66662598</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="1" >1788.66699219</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="4" >1788.667</value>
<value id="{43502468-8c8c-46ca-8860-9f9058bee7ba}" mode="1" >2.96025991</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="1" >2.96025991</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="4" >2.960</value>
<value id="{e9016c23-32cb-4e49-9796-4f759e833b0b}" mode="4" >0</value>
<value id="{81b9447d-4c7b-4fad-8809-d7b9627b0ebb}" mode="4" >0</value>
<value id="{41f5ac06-3b49-4566-809d-7a09abfc655e}" mode="1" >1.00000000</value>
<value id="{4bbe1673-18da-4fd2-b5c8-ca683b2e3264}" mode="1" >0.60000002</value>
<value id="{0997e946-6716-4b3e-9b85-c9d9f2dff660}" mode="1" >0.87000000</value>
<value id="{c9e7de4c-fd40-48e8-92fa-82dc416d3db4}" mode="1" >1.00000000</value>
</preset>
<preset name="Rhythm #01 " number="10" >
<value id="{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}" mode="1" >0.83636361</value>
<value id="{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}" mode="1" >0.92727274</value>
<value id="{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}" mode="1" >0.83636361</value>
<value id="{374dbca9-a526-4d0e-b5e3-90478049b6bf}" mode="1" >0.77999997</value>
<value id="{056dbef4-8826-4d69-8e6a-852c4edc2ea8}" mode="1" >1.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="1" >1.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="4" >1</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="1" >0.00000000</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="4" >0</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="1" >1.00000000</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="4" >1</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="1" >0.00000000</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="4" >0</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="1" >1.00000000</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="4" >1</value>
<value id="{34836809-f2ae-40bf-83f4-70afd41e31d5}" mode="1" >1.00000000</value>
<value id="{1feef608-a361-4450-ab55-7696af9b3ae4}" mode="1" >2.00000000</value>
<value id="{c78a7996-cc03-400d-b5c3-0345e930d720}" mode="1" >12000.00000000</value>
<value id="{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}" mode="1" >4000.00000000</value>
<value id="{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}" mode="1" >150.00000000</value>
<value id="{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}" mode="1" >1.00000000</value>
<value id="{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}" mode="4" >0</value>
<value id="{3dbe21c8-d134-48a2-a35d-06b231b2d800}" mode="1" >-255.00000000</value>
<value id="{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}" mode="1" >0.00000000</value>
<value id="{1fba5c43-d60e-49dc-8e1f-34467529754f}" mode="1" >2.01399994</value>
<value id="{57e07eec-f065-407f-bc8b-652ff42dd6da}" mode="1" >25.74500084</value>
<value id="{f4be3e35-886e-4424-96f9-a8caee28dace}" mode="1" >162.00000000</value>
<value id="{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}" mode="1" >162.00000000</value>
<value id="{e9d00afa-2d17-4143-aae7-0a9add2429a8}" mode="1" >295.00039673</value>
<value id="{f63e36a9-4510-4b12-bd82-62fa0686ba4f}" mode="1" >150.00000000</value>
<value id="{48dcad2d-eb3e-42a7-9793-ed2e19355426}" mode="1" >4000.00000000</value>
<value id="{6f061ce3-ab4b-4e1a-853f-42e97952075c}" mode="1" >12000.00000000</value>
<value id="{52f30728-cf31-43c5-abd5-9968e6f45bae}" mode="1" >25.74500084</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="1" >0.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="2" >0.93846154</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="1" >0.00000000</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="2" >0.70769233</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="1" >0.00000000</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="2" >0.33076924</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="1" >0.00000000</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="2" >0.93846154</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="1" >0.00000000</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="2" >0.60000002</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="1" >0.00000000</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="2" >0.55384612</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="1" >0.00000000</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="2" >0.33846155</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="1" >0.00000000</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="2" >0.53076923</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="1" >0.00000000</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="2" >0.93846154</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="1" >0.00000000</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="2" >0.69999999</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="1" >0.00000000</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="2" >0.48461539</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="1" >0.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="2" >0.74615383</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="1" >0.00000000</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="2" >0.88461536</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="1" >0.00000000</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="2" >0.33076924</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="1" >0.00000000</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="2" >802.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="1" >0.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="2" >386.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="1" >0.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="2" >308.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="1" >0.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="2" >178.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="1" >0.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="2" >308.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="1" >0.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="2" >282.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="1" >0.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="2" >516.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="1" >0.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="2" >256.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="1" >0.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="2" >542.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="1" >0.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="2" >464.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="1" >0.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="2" >308.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="1" >0.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="2" >308.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="1" >308.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="4" >308.000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="1" >802.00000000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="4" >802.000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="1" >386.00000000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="4" >386.000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="1" >308.00000000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="4" >308.000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="1" >178.00000000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="4" >178.000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="1" >308.00000000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="4" >308.000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="1" >282.00000000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="4" >282.000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="1" >516.00000000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="4" >516.000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="1" >256.00000000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="4" >256.000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="1" >542.00000000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="4" >542.000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="1" >464.00000000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="4" >464.000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="1" >308.00000000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="4" >308.000</value>
<value id="{bf83e1da-fb92-4782-b291-79f2fadbc31b}" mode="1" >0.00100000</value>
<value id="{b29455b4-1f35-4da7-b6e3-1d26749f211b}" mode="1" >0.94006002</value>
<value id="{019ab94d-9192-4b84-9baa-480b3d8a287a}" mode="1" >1.25999999</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="1" >0.00100000</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="4" >0.001</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="1" >0.94006002</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="4" >0.940</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="1" >1.25999999</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="4" >1.260</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="1" >0.00000000</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="2" >0.63076925</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="1" >0.00000000</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="2" >0.14615385</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="1" >0.00000000</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="2" >0.66923076</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="1" >0.00000000</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="2" >0.23846154</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="1" >0.00000000</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="2" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="1" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="4" >1292.000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="1" >0.00000000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="2" >795.33331299</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="1" >795.33300781</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="4" >795.333</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="1" >0.00000000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="2" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="1" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="4" >696.000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="1" >0.00000000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="2" >100.00000000</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="1" >100.00000000</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="4" >100.000</value>
<value id="{43502468-8c8c-46ca-8860-9f9058bee7ba}" mode="1" >2.96025991</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="1" >2.96025991</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="4" >2.960</value>
<value id="{e9016c23-32cb-4e49-9796-4f759e833b0b}" mode="4" >0</value>
<value id="{81b9447d-4c7b-4fad-8809-d7b9627b0ebb}" mode="4" >0</value>
<value id="{41f5ac06-3b49-4566-809d-7a09abfc655e}" mode="1" >1.00000000</value>
<value id="{4bbe1673-18da-4fd2-b5c8-ca683b2e3264}" mode="1" >0.00000000</value>
<value id="{0997e946-6716-4b3e-9b85-c9d9f2dff660}" mode="1" >0.87000000</value>
<value id="{c9e7de4c-fd40-48e8-92fa-82dc416d3db4}" mode="1" >1.00000000</value>
</preset>
<preset name="Rhythm #01" number="11" >
<value id="{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}" mode="1" >0.83636361</value>
<value id="{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}" mode="1" >0.92727274</value>
<value id="{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}" mode="1" >0.83636361</value>
<value id="{374dbca9-a526-4d0e-b5e3-90478049b6bf}" mode="1" >0.77999997</value>
<value id="{056dbef4-8826-4d69-8e6a-852c4edc2ea8}" mode="1" >1.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="1" >1.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="4" >1</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="1" >0.00000000</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="4" >0</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="1" >1.00000000</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="4" >1</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="1" >0.00000000</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="4" >0</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="1" >1.00000000</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="4" >1</value>
<value id="{34836809-f2ae-40bf-83f4-70afd41e31d5}" mode="1" >1.00000000</value>
<value id="{1feef608-a361-4450-ab55-7696af9b3ae4}" mode="1" >1.16818178</value>
<value id="{c78a7996-cc03-400d-b5c3-0345e930d720}" mode="1" >12000.00000000</value>
<value id="{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}" mode="1" >4000.00000000</value>
<value id="{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}" mode="1" >150.00000000</value>
<value id="{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}" mode="1" >1.00000000</value>
<value id="{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}" mode="4" >0</value>
<value id="{3dbe21c8-d134-48a2-a35d-06b231b2d800}" mode="1" >-255.00000000</value>
<value id="{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}" mode="1" >0.00000000</value>
<value id="{1fba5c43-d60e-49dc-8e1f-34467529754f}" mode="1" >1.43400002</value>
<value id="{57e07eec-f065-407f-bc8b-652ff42dd6da}" mode="1" >0.50000000</value>
<value id="{f4be3e35-886e-4424-96f9-a8caee28dace}" mode="1" >162.00000000</value>
<value id="{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}" mode="1" >162.00000000</value>
<value id="{e9d00afa-2d17-4143-aae7-0a9add2429a8}" mode="1" >300.00039673</value>
<value id="{f63e36a9-4510-4b12-bd82-62fa0686ba4f}" mode="1" >150.00000000</value>
<value id="{48dcad2d-eb3e-42a7-9793-ed2e19355426}" mode="1" >4000.00000000</value>
<value id="{6f061ce3-ab4b-4e1a-853f-42e97952075c}" mode="1" >12000.00000000</value>
<value id="{52f30728-cf31-43c5-abd5-9968e6f45bae}" mode="1" >0.50000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="1" >0.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="2" >0.35384616</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="1" >0.00000000</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="2" >0.40000001</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="1" >0.00000000</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="2" >0.33076924</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="1" >0.00000000</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="2" >0.35384616</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="1" >0.00000000</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="2" >0.60000002</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="1" >0.00000000</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="2" >0.55384612</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="1" >0.00000000</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="2" >0.33846155</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="1" >0.00000000</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="2" >0.53076923</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="1" >0.00000000</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="2" >0.35384616</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="1" >0.00000000</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="2" >0.69999999</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="1" >0.00000000</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="2" >0.48461539</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="1" >0.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="2" >0.50769234</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="1" >0.00000000</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="2" >0.25384617</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="1" >0.00000000</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="2" >0.33076924</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="1" >0.00000000</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="2" >334.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="1" >0.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="2" >542.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="1" >0.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="2" >1114.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="1" >0.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="2" >464.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="1" >0.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="2" >308.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="1" >0.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="2" >880.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="1" >0.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="2" >1270.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="1" >0.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="2" >256.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="1" >0.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="2" >542.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="1" >0.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="2" >464.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="1" >0.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="2" >100.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="1" >0.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="2" >308.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="1" >100.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="4" >100.000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="1" >334.00000000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="4" >334.000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="1" >542.00000000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="4" >542.000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="1" >1114.00000000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="4" >1114.000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="1" >464.00000000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="4" >464.000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="1" >308.00000000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="4" >308.000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="1" >880.00000000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="4" >880.000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="1" >1270.00000000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="4" >1270.000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="1" >256.00000000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="4" >256.000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="1" >542.00000000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="4" >542.000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="1" >464.00000000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="4" >464.000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="1" >308.00000000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="4" >308.000</value>
<value id="{bf83e1da-fb92-4782-b291-79f2fadbc31b}" mode="1" >0.00100000</value>
<value id="{b29455b4-1f35-4da7-b6e3-1d26749f211b}" mode="1" >1.00000000</value>
<value id="{019ab94d-9192-4b84-9baa-480b3d8a287a}" mode="1" >1.25999999</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="1" >0.00100000</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="4" >0.001</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="1" >1.00000000</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="4" >1.000</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="1" >1.25999999</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="4" >1.260</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="1" >0.00000000</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="2" >0.63076925</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="1" >0.00000000</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="2" >0.14615385</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="1" >0.00000000</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="2" >0.15384616</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="1" >0.00000000</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="2" >0.23846154</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="1" >0.00000000</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="2" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="1" >1292.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="4" >1292.000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="1" >0.00000000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="2" >795.33331299</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="1" >795.33300781</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="4" >795.333</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="1" >0.00000000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="2" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="1" >696.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="4" >696.000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="1" >0.00000000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="2" >1192.66662598</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="1" >1192.66662598</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="4" >1192.667</value>
<value id="{43502468-8c8c-46ca-8860-9f9058bee7ba}" mode="1" >2.96025991</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="1" >2.96025991</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="4" >2.960</value>
<value id="{e9016c23-32cb-4e49-9796-4f759e833b0b}" mode="4" >0</value>
<value id="{81b9447d-4c7b-4fad-8809-d7b9627b0ebb}" mode="4" >0</value>
<value id="{41f5ac06-3b49-4566-809d-7a09abfc655e}" mode="1" >1.00000000</value>
<value id="{4bbe1673-18da-4fd2-b5c8-ca683b2e3264}" mode="1" >0.00000000</value>
<value id="{0997e946-6716-4b3e-9b85-c9d9f2dff660}" mode="1" >0.87000000</value>
<value id="{c9e7de4c-fd40-48e8-92fa-82dc416d3db4}" mode="1" >1.00000000</value>
</preset>
<preset name="Harmonic Mixture" number="9" >
<value id="{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}" mode="1" >0.83636361</value>
<value id="{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}" mode="1" >0.92727274</value>
<value id="{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}" mode="1" >0.83636361</value>
<value id="{374dbca9-a526-4d0e-b5e3-90478049b6bf}" mode="1" >0.77999997</value>
<value id="{056dbef4-8826-4d69-8e6a-852c4edc2ea8}" mode="1" >1.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="1" >0.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="4" >0</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="1" >0.00000000</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="4" >0</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="1" >0.00000000</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="4" >0</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="1" >0.00000000</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="4" >0</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="1" >0.00000000</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="4" >0</value>
<value id="{34836809-f2ae-40bf-83f4-70afd41e31d5}" mode="1" >1.00000000</value>
<value id="{1feef608-a361-4450-ab55-7696af9b3ae4}" mode="1" >1.61818182</value>
<value id="{c78a7996-cc03-400d-b5c3-0345e930d720}" mode="1" >6106.66650391</value>
<value id="{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}" mode="1" >2031.06799316</value>
<value id="{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}" mode="1" >89.24272156</value>
<value id="{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}" mode="1" >1.00000000</value>
<value id="{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}" mode="4" >0</value>
<value id="{3dbe21c8-d134-48a2-a35d-06b231b2d800}" mode="1" >-255.00000000</value>
<value id="{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}" mode="1" >0.00000000</value>
<value id="{1fba5c43-d60e-49dc-8e1f-34467529754f}" mode="1" >2.18799996</value>
<value id="{57e07eec-f065-407f-bc8b-652ff42dd6da}" mode="1" >0.50000000</value>
<value id="{f4be3e35-886e-4424-96f9-a8caee28dace}" mode="1" >0.00000000</value>
<value id="{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}" mode="1" >0.00000000</value>
<value id="{e9d00afa-2d17-4143-aae7-0a9add2429a8}" mode="1" >295.00039673</value>
<value id="{f63e36a9-4510-4b12-bd82-62fa0686ba4f}" mode="1" >89.24272156</value>
<value id="{48dcad2d-eb3e-42a7-9793-ed2e19355426}" mode="1" >2031.06799316</value>
<value id="{6f061ce3-ab4b-4e1a-853f-42e97952075c}" mode="1" >6106.66650391</value>
<value id="{52f30728-cf31-43c5-abd5-9968e6f45bae}" mode="1" >0.50000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="1" >0.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="2" >0.90769231</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="1" >0.00000000</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="2" >0.68461537</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="1" >0.00000000</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="2" >0.69230771</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="1" >0.00000000</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="2" >0.90769231</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="1" >0.00000000</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="2" >0.60000002</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="1" >0.00000000</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="2" >0.55384612</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="1" >0.00000000</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="2" >0.74615383</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="1" >0.00000000</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="2" >0.53076923</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="1" >0.00000000</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="2" >0.90769231</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="1" >0.00000000</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="2" >0.69999999</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="1" >0.00000000</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="2" >0.69230771</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="1" >0.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="2" >0.50769234</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="1" >0.00000000</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="2" >0.76153845</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="1" >0.00000000</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="2" >0.33076924</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="1" >0.00000000</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="2" >240.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="1" >0.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="2" >360.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="1" >0.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="2" >480.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="1" >0.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="2" >600.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="1" >0.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="2" >720.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="1" >0.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="2" >840.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="1" >0.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="2" >960.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="1" >0.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="2" >1080.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="1" >0.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="2" >1200.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="1" >0.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="2" >1320.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="1" >0.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="2" >120.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="1" >0.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="2" >1440.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="1" >120.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="4" >120.000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="1" >240.00000000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="4" >240.000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="1" >360.00000000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="4" >360.000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="1" >480.00000000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="4" >480.000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="1" >600.00000000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="4" >600.000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="1" >720.00000000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="4" >720.000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="1" >840.00000000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="4" >840.000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="1" >960.00000000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="4" >960.000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="1" >1080.00000000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="4" >1080.000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="1" >1200.00000000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="4" >1200.000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="1" >1320.00000000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="4" >1320.000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="1" >1440.00000000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="4" >1440.000</value>
<value id="{bf83e1da-fb92-4782-b291-79f2fadbc31b}" mode="1" >0.74062997</value>
<value id="{b29455b4-1f35-4da7-b6e3-1d26749f211b}" mode="1" >1.00000000</value>
<value id="{019ab94d-9192-4b84-9baa-480b3d8a287a}" mode="1" >1.25999999</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="1" >0.74062997</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="4" >0.741</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="1" >1.00000000</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="4" >1.000</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="1" >1.25999999</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="4" >1.260</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="1" >0.00000000</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="2" >0.53076923</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="1" >0.00000000</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="2" >0.76153845</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="1" >0.00000000</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="2" >0.75384617</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="1" >0.00000000</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="2" >0.64615387</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="1" >0.00000000</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="2" >1560.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="1" >1560.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="4" >1560.000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="1" >0.00000000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="2" >1680.00000000</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="1" >1680.00000000</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="4" >1680.000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="1" >0.00000000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="2" >1800.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="1" >1800.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="4" >1800.000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="1" >0.00000000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="2" >1920.00000000</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="1" >1920.00000000</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="4" >1920.000</value>
<value id="{43502468-8c8c-46ca-8860-9f9058bee7ba}" mode="1" >2.96025991</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="1" >2.96025991</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="4" >2.960</value>
<value id="{e9016c23-32cb-4e49-9796-4f759e833b0b}" mode="4" >0</value>
<value id="{81b9447d-4c7b-4fad-8809-d7b9627b0ebb}" mode="4" >0</value>
<value id="{41f5ac06-3b49-4566-809d-7a09abfc655e}" mode="1" >0.00000000</value>
<value id="{4bbe1673-18da-4fd2-b5c8-ca683b2e3264}" mode="1" >0.83999997</value>
<value id="{0997e946-6716-4b3e-9b85-c9d9f2dff660}" mode="1" >0.81000000</value>
<value id="{c9e7de4c-fd40-48e8-92fa-82dc416d3db4}" mode="1" >1.00000000</value>
</preset>
<preset name="Fibonacci Bells" number="7" >
<value id="{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}" mode="1" >0.66000003</value>
<value id="{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}" mode="1" >0.69000000</value>
<value id="{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}" mode="1" >0.40000001</value>
<value id="{374dbca9-a526-4d0e-b5e3-90478049b6bf}" mode="1" >0.77999997</value>
<value id="{056dbef4-8826-4d69-8e6a-852c4edc2ea8}" mode="1" >0.58999997</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="1" >0.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="4" >0</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="1" >0.00000000</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="4" >0</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="1" >0.00000000</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="4" >0</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="1" >0.00000000</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="4" >0</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="1" >0.00000000</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="4" >0</value>
<value id="{34836809-f2ae-40bf-83f4-70afd41e31d5}" mode="1" >0.74000001</value>
<value id="{1feef608-a361-4450-ab55-7696af9b3ae4}" mode="1" >2.00000000</value>
<value id="{c78a7996-cc03-400d-b5c3-0345e930d720}" mode="1" >8311.00000000</value>
<value id="{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}" mode="1" >1387.00000000</value>
<value id="{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}" mode="1" >96.36000061</value>
<value id="{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}" mode="1" >1.00000000</value>
<value id="{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}" mode="4" >0</value>
<value id="{3dbe21c8-d134-48a2-a35d-06b231b2d800}" mode="1" >-255.00000000</value>
<value id="{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}" mode="1" >7.00000000</value>
<value id="{1fba5c43-d60e-49dc-8e1f-34467529754f}" mode="1" >3.00000000</value>
<value id="{57e07eec-f065-407f-bc8b-652ff42dd6da}" mode="1" >0.50000000</value>
<value id="{f4be3e35-886e-4424-96f9-a8caee28dace}" mode="1" >0.00000000</value>
<value id="{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}" mode="1" >0.00000000</value>
<value id="{e9d00afa-2d17-4143-aae7-0a9add2429a8}" mode="1" >210.00057983</value>
<value id="{f63e36a9-4510-4b12-bd82-62fa0686ba4f}" mode="1" >56.13000107</value>
<value id="{48dcad2d-eb3e-42a7-9793-ed2e19355426}" mode="1" >1387.00000000</value>
<value id="{6f061ce3-ab4b-4e1a-853f-42e97952075c}" mode="1" >8311.00000000</value>
<value id="{52f30728-cf31-43c5-abd5-9968e6f45bae}" mode="1" >0.50000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="1" >0.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="2" >0.93846154</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="1" >0.00000000</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="2" >0.12307692</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="1" >0.00000000</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="2" >0.33076924</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="1" >0.00000000</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="2" >0.93846154</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="1" >0.00000000</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="2" >0.43076923</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="1" >0.00000000</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="2" >0.55384612</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="1" >0.00000000</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="2" >0.41538462</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="1" >0.00000000</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="2" >0.53076923</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="1" >0.00000000</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="2" >0.93846154</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="1" >0.00000000</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="2" >0.69999999</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="1" >0.00000000</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="2" >0.48461539</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="1" >0.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="2" >0.74615383</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="1" >0.00000000</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="2" >0.89230770</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="1" >0.00000000</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="2" >0.33076924</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="1" >0.00000000</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="2" >288.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="1" >0.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="2" >220.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="1" >0.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="2" >356.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="1" >0.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="2" >576.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="1" >0.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="2" >330.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="1" >0.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="2" >534.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="1" >0.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="2" >864.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="1" >0.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="2" >440.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="1" >0.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="2" >712.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="1" >0.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="2" >1152.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="1" >0.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="2" >110.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="1" >0.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="2" >550.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="1" >110.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="4" >110.000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="1" >288.00000000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="4" >288.000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="1" >220.00000000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="4" >220.000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="1" >356.00000000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="4" >356.000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="1" >576.00000000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="4" >576.000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="1" >330.00000000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="4" >330.000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="1" >534.00000000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="4" >534.000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="1" >864.00000000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="4" >864.000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="1" >440.00000000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="4" >440.000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="1" >712.00000000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="4" >712.000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="1" >1152.00000000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="4" >1152.000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="1" >550.00000000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="4" >550.000</value>
<value id="{bf83e1da-fb92-4782-b291-79f2fadbc31b}" mode="1" >0.00100000</value>
<value id="{b29455b4-1f35-4da7-b6e3-1d26749f211b}" mode="1" >0.76024002</value>
<value id="{019ab94d-9192-4b84-9baa-480b3d8a287a}" mode="1" >1.15999997</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="1" >0.00100000</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="4" >0.001</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="1" >0.75999999</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="4" >0.760</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="1" >1.15999997</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="4" >1.160</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="1" >0.00000000</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="2" >0.05384615</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="1" >0.00000000</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="2" >0.14615385</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="1" >0.00000000</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="2" >0.23846154</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="1" >0.00000000</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="2" >0.23846154</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="1" >0.00000000</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="2" >890.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="1" >890.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="4" >890.000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="1" >0.00000000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="2" >660.00000000</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="1" >660.00000000</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="4" >660.000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="1" >0.00000000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="2" >1068.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="1" >1068.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="4" >1068.000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="1" >0.00000000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="2" >1728.00000000</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="1" >1728.00000000</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="4" >1728.000</value>
<value id="{43502468-8c8c-46ca-8860-9f9058bee7ba}" mode="1" >2.96025991</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="1" >2.96000004</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="4" >2.960</value>
<value id="{e9016c23-32cb-4e49-9796-4f759e833b0b}" mode="4" >0</value>
<value id="{81b9447d-4c7b-4fad-8809-d7b9627b0ebb}" mode="4" >0</value>
<value id="{41f5ac06-3b49-4566-809d-7a09abfc655e}" mode="1" >7.00000000</value>
<value id="{4bbe1673-18da-4fd2-b5c8-ca683b2e3264}" mode="1" >0.88999999</value>
<value id="{0997e946-6716-4b3e-9b85-c9d9f2dff660}" mode="1" >0.87000000</value>
<value id="{c9e7de4c-fd40-48e8-92fa-82dc416d3db4}" mode="1" >1.00000000</value>
<value id="{91ffa259-7ff9-46d2-bbbf-ed0be213a299}" mode="4" >0</value>
</preset>
<preset name="Pi Greco Railing" number="8" >
<value id="{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}" mode="1" >0.66000003</value>
<value id="{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}" mode="1" >0.69000000</value>
<value id="{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}" mode="1" >0.40000001</value>
<value id="{374dbca9-a526-4d0e-b5e3-90478049b6bf}" mode="1" >0.77999997</value>
<value id="{056dbef4-8826-4d69-8e6a-852c4edc2ea8}" mode="1" >0.58999997</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="1" >0.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="4" >0</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="1" >0.00000000</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="4" >0</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="1" >0.00000000</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="4" >0</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="1" >0.00000000</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="4" >0</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="1" >0.00000000</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="4" >0</value>
<value id="{34836809-f2ae-40bf-83f4-70afd41e31d5}" mode="1" >0.74000001</value>
<value id="{1feef608-a361-4450-ab55-7696af9b3ae4}" mode="1" >2.00000000</value>
<value id="{c78a7996-cc03-400d-b5c3-0345e930d720}" mode="1" >8311.00000000</value>
<value id="{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}" mode="1" >1387.00000000</value>
<value id="{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}" mode="1" >96.36000061</value>
<value id="{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}" mode="1" >1.00000000</value>
<value id="{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}" mode="4" >0</value>
<value id="{3dbe21c8-d134-48a2-a35d-06b231b2d800}" mode="1" >-255.00000000</value>
<value id="{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}" mode="1" >7.00000000</value>
<value id="{1fba5c43-d60e-49dc-8e1f-34467529754f}" mode="1" >3.00000000</value>
<value id="{57e07eec-f065-407f-bc8b-652ff42dd6da}" mode="1" >0.50000000</value>
<value id="{f4be3e35-886e-4424-96f9-a8caee28dace}" mode="1" >0.00000000</value>
<value id="{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}" mode="1" >0.00000000</value>
<value id="{e9d00afa-2d17-4143-aae7-0a9add2429a8}" mode="1" >210.00057983</value>
<value id="{f63e36a9-4510-4b12-bd82-62fa0686ba4f}" mode="1" >56.13000107</value>
<value id="{48dcad2d-eb3e-42a7-9793-ed2e19355426}" mode="1" >1387.00000000</value>
<value id="{6f061ce3-ab4b-4e1a-853f-42e97952075c}" mode="1" >8311.00000000</value>
<value id="{52f30728-cf31-43c5-abd5-9968e6f45bae}" mode="1" >0.50000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="1" >0.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="2" >0.93846154</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="1" >0.00000000</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="2" >0.12307692</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="1" >0.00000000</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="2" >0.33076924</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="1" >0.00000000</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="2" >0.93846154</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="1" >0.00000000</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="2" >0.43076923</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="1" >0.00000000</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="2" >0.55384612</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="1" >0.00000000</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="2" >0.41538462</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="1" >0.00000000</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="2" >0.53076923</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="1" >0.00000000</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="2" >0.93846154</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="1" >0.00000000</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="2" >0.69999999</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="1" >0.00000000</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="2" >0.48461539</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="1" >0.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="2" >0.74615383</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="1" >0.00000000</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="2" >0.89230770</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="1" >0.00000000</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="2" >0.33076924</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="1" >0.00000000</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="2" >40.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="1" >0.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="2" >126.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="1" >0.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="2" >60.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="1" >0.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="2" >188.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="1" >0.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="2" >80.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="1" >0.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="2" >251.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="1" >0.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="2" >100.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="1" >0.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="2" >314.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="1" >0.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="2" >120.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="1" >0.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="2" >377.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="1" >0.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="2" >20.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="1" >0.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="2" >140.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="1" >20.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="4" >20.000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="1" >40.00000000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="4" >40.000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="1" >126.00000000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="4" >126.000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="1" >60.00000000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="4" >60.000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="1" >188.00000000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="4" >188.000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="1" >80.00000000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="4" >80.000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="1" >251.00000000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="4" >251.000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="1" >100.00000000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="4" >100.000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="1" >314.00000000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="4" >314.000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="1" >120.00000000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="4" >120.000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="1" >377.00000000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="4" >377.000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="1" >140.00000000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="4" >140.000</value>
<value id="{bf83e1da-fb92-4782-b291-79f2fadbc31b}" mode="1" >0.00100000</value>
<value id="{b29455b4-1f35-4da7-b6e3-1d26749f211b}" mode="1" >0.76024002</value>
<value id="{019ab94d-9192-4b84-9baa-480b3d8a287a}" mode="1" >1.15999997</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="1" >0.00100000</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="4" >0.001</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="1" >0.75999999</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="4" >0.760</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="1" >1.15999997</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="4" >1.160</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="1" >0.00000000</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="2" >0.05384615</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="1" >0.00000000</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="2" >0.14615385</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="1" >0.00000000</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="2" >0.23846154</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="1" >0.00000000</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="2" >0.23846154</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="1" >0.00000000</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="2" >440.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="1" >440.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="4" >440.000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="1" >0.00000000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="2" >160.00000000</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="1" >160.00000000</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="4" >160.000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="1" >0.00000000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="2" >502.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="1" >502.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="4" >502.000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="1" >0.00000000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="2" >180.00000000</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="1" >180.00000000</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="4" >180.000</value>
<value id="{43502468-8c8c-46ca-8860-9f9058bee7ba}" mode="1" >2.96025991</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="1" >2.96000004</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="4" >2.960</value>
<value id="{e9016c23-32cb-4e49-9796-4f759e833b0b}" mode="4" >0</value>
<value id="{81b9447d-4c7b-4fad-8809-d7b9627b0ebb}" mode="4" >0</value>
<value id="{41f5ac06-3b49-4566-809d-7a09abfc655e}" mode="1" >7.00000000</value>
<value id="{4bbe1673-18da-4fd2-b5c8-ca683b2e3264}" mode="1" >0.88999999</value>
<value id="{0997e946-6716-4b3e-9b85-c9d9f2dff660}" mode="1" >0.87000000</value>
<value id="{c9e7de4c-fd40-48e8-92fa-82dc416d3db4}" mode="1" >1.00000000</value>
<value id="{91ffa259-7ff9-46d2-bbbf-ed0be213a299}" mode="4" >0</value>
<value id="{652306da-467b-4488-9b99-fba18e1b5c12}" mode="4" >0</value>
<value id="{452a036d-c30b-4645-9052-1c73b35c16a0}" mode="4" >0</value>
<value id="{02ec4190-bca5-46ba-bc1e-215a1150bacc}" mode="4" >0</value>
<value id="{62bf5767-3df9-4e22-9156-64525155ee9b}" mode="4" >0</value>
</preset>
<preset name="2.35 Relationship" number="13" >
<value id="{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}" mode="1" >0.66000003</value>
<value id="{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}" mode="1" >0.69000000</value>
<value id="{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}" mode="1" >0.40000001</value>
<value id="{374dbca9-a526-4d0e-b5e3-90478049b6bf}" mode="1" >0.77999997</value>
<value id="{056dbef4-8826-4d69-8e6a-852c4edc2ea8}" mode="1" >0.58999997</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="1" >0.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="4" >0</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="1" >0.00000000</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="4" >0</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="1" >0.00000000</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="4" >0</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="1" >0.00000000</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="4" >0</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="1" >0.00000000</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="4" >0</value>
<value id="{34836809-f2ae-40bf-83f4-70afd41e31d5}" mode="1" >0.74000001</value>
<value id="{1feef608-a361-4450-ab55-7696af9b3ae4}" mode="1" >2.00000000</value>
<value id="{c78a7996-cc03-400d-b5c3-0345e930d720}" mode="1" >8311.00000000</value>
<value id="{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}" mode="1" >1387.00000000</value>
<value id="{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}" mode="1" >96.36000061</value>
<value id="{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}" mode="1" >1.00000000</value>
<value id="{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}" mode="4" >0</value>
<value id="{3dbe21c8-d134-48a2-a35d-06b231b2d800}" mode="1" >-255.00000000</value>
<value id="{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}" mode="1" >7.00000000</value>
<value id="{1fba5c43-d60e-49dc-8e1f-34467529754f}" mode="1" >3.00000000</value>
<value id="{57e07eec-f065-407f-bc8b-652ff42dd6da}" mode="1" >0.50000000</value>
<value id="{f4be3e35-886e-4424-96f9-a8caee28dace}" mode="1" >0.00000000</value>
<value id="{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}" mode="1" >0.00000000</value>
<value id="{e9d00afa-2d17-4143-aae7-0a9add2429a8}" mode="1" >210.00057983</value>
<value id="{f63e36a9-4510-4b12-bd82-62fa0686ba4f}" mode="1" >56.13000107</value>
<value id="{48dcad2d-eb3e-42a7-9793-ed2e19355426}" mode="1" >1387.00000000</value>
<value id="{6f061ce3-ab4b-4e1a-853f-42e97952075c}" mode="1" >8311.00000000</value>
<value id="{52f30728-cf31-43c5-abd5-9968e6f45bae}" mode="1" >0.50000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="1" >0.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="2" >0.93846154</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="1" >0.00000000</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="2" >0.12307692</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="1" >0.00000000</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="2" >0.33076924</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="1" >0.00000000</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="2" >0.93846154</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="1" >0.00000000</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="2" >0.43076923</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="1" >0.00000000</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="2" >0.55384612</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="1" >0.00000000</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="2" >0.41538462</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="1" >0.00000000</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="2" >0.53076923</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="1" >0.00000000</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="2" >0.93846154</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="1" >0.00000000</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="2" >0.69999999</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="1" >0.00000000</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="2" >0.48461539</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="1" >0.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="2" >0.74615383</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="1" >0.00000000</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="2" >0.89230770</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="1" >0.00000000</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="2" >0.33076924</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="1" >0.00000000</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="2" >198.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="1" >0.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="2" >264.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="1" >0.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="2" >330.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="1" >0.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="2" >396.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="1" >0.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="2" >462.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="1" >0.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="2" >528.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="1" >0.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="2" >594.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="1" >0.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="2" >660.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="1" >0.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="2" >726.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="1" >0.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="2" >792.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="1" >0.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="2" >66.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="1" >0.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="2" >858.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="1" >66.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="4" >66.000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="1" >198.00000000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="4" >198.000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="1" >264.00000000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="4" >264.000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="1" >330.00000000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="4" >330.000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="1" >396.00000000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="4" >396.000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="1" >462.00000000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="4" >462.000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="1" >528.00000000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="4" >528.000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="1" >594.00000000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="4" >594.000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="1" >660.00000000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="4" >660.000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="1" >726.00000000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="4" >726.000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="1" >792.00000000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="4" >792.000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="1" >858.00000000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="4" >858.000</value>
<value id="{bf83e1da-fb92-4782-b291-79f2fadbc31b}" mode="1" >0.00100000</value>
<value id="{b29455b4-1f35-4da7-b6e3-1d26749f211b}" mode="1" >0.76024002</value>
<value id="{019ab94d-9192-4b84-9baa-480b3d8a287a}" mode="1" >1.15999997</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="1" >0.00100000</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="4" >0.001</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="1" >0.75999999</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="4" >0.760</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="1" >1.15999997</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="4" >1.160</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="1" >0.00000000</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="2" >0.05384615</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="1" >0.00000000</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="2" >0.14615385</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="1" >0.00000000</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="2" >0.23846154</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="1" >0.00000000</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="2" >0.23846154</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="1" >0.00000000</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="2" >924.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="1" >924.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="4" >924.000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="1" >0.00000000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="2" >990.00000000</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="1" >990.00000000</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="4" >990.000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="1" >0.00000000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="2" >1056.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="1" >1056.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="4" >1056.000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="1" >0.00000000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="2" >1122.00000000</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="1" >1122.00000000</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="4" >1122.000</value>
<value id="{43502468-8c8c-46ca-8860-9f9058bee7ba}" mode="1" >2.96025991</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="1" >2.96000004</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="4" >2.960</value>
<value id="{e9016c23-32cb-4e49-9796-4f759e833b0b}" mode="4" >0</value>
<value id="{81b9447d-4c7b-4fad-8809-d7b9627b0ebb}" mode="4" >0</value>
<value id="{41f5ac06-3b49-4566-809d-7a09abfc655e}" mode="1" >7.00000000</value>
<value id="{4bbe1673-18da-4fd2-b5c8-ca683b2e3264}" mode="1" >0.88999999</value>
<value id="{0997e946-6716-4b3e-9b85-c9d9f2dff660}" mode="1" >0.87000000</value>
<value id="{c9e7de4c-fd40-48e8-92fa-82dc416d3db4}" mode="1" >1.00000000</value>
<value id="{91ffa259-7ff9-46d2-bbbf-ed0be213a299}" mode="4" >0</value>
<value id="{652306da-467b-4488-9b99-fba18e1b5c12}" mode="4" >0</value>
<value id="{452a036d-c30b-4645-9052-1c73b35c16a0}" mode="4" >0</value>
<value id="{02ec4190-bca5-46ba-bc1e-215a1150bacc}" mode="4" >0</value>
<value id="{62bf5767-3df9-4e22-9156-64525155ee9b}" mode="4" >0</value>
</preset>
<preset name="A Inharmonic BeLL" number="14" >
<value id="{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}" mode="1" >0.66000003</value>
<value id="{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}" mode="1" >0.69000000</value>
<value id="{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}" mode="1" >0.40000001</value>
<value id="{374dbca9-a526-4d0e-b5e3-90478049b6bf}" mode="1" >0.77999997</value>
<value id="{056dbef4-8826-4d69-8e6a-852c4edc2ea8}" mode="1" >0.58999997</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="1" >0.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="4" >0</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="1" >0.00000000</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="4" >0</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="1" >0.00000000</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="4" >0</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="1" >0.00000000</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="4" >0</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="1" >0.00000000</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="4" >0</value>
<value id="{34836809-f2ae-40bf-83f4-70afd41e31d5}" mode="1" >0.74000001</value>
<value id="{1feef608-a361-4450-ab55-7696af9b3ae4}" mode="1" >2.00000000</value>
<value id="{c78a7996-cc03-400d-b5c3-0345e930d720}" mode="1" >8311.00000000</value>
<value id="{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}" mode="1" >1387.00000000</value>
<value id="{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}" mode="1" >96.36000061</value>
<value id="{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}" mode="1" >1.00000000</value>
<value id="{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}" mode="4" >0</value>
<value id="{3dbe21c8-d134-48a2-a35d-06b231b2d800}" mode="1" >-255.00000000</value>
<value id="{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}" mode="1" >7.00000000</value>
<value id="{1fba5c43-d60e-49dc-8e1f-34467529754f}" mode="1" >3.00000000</value>
<value id="{57e07eec-f065-407f-bc8b-652ff42dd6da}" mode="1" >0.50000000</value>
<value id="{f4be3e35-886e-4424-96f9-a8caee28dace}" mode="1" >0.00000000</value>
<value id="{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}" mode="1" >0.00000000</value>
<value id="{e9d00afa-2d17-4143-aae7-0a9add2429a8}" mode="1" >210.00057983</value>
<value id="{f63e36a9-4510-4b12-bd82-62fa0686ba4f}" mode="1" >56.13000107</value>
<value id="{48dcad2d-eb3e-42a7-9793-ed2e19355426}" mode="1" >1387.00000000</value>
<value id="{6f061ce3-ab4b-4e1a-853f-42e97952075c}" mode="1" >8311.00000000</value>
<value id="{52f30728-cf31-43c5-abd5-9968e6f45bae}" mode="1" >0.50000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="1" >0.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="2" >0.93846154</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="1" >0.00000000</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="2" >0.12307692</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="1" >0.00000000</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="2" >0.33076924</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="1" >0.00000000</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="2" >0.93846154</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="1" >0.00000000</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="2" >0.43076923</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="1" >0.00000000</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="2" >0.55384612</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="1" >0.00000000</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="2" >0.41538462</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="1" >0.00000000</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="2" >0.53076923</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="1" >0.00000000</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="2" >0.93846154</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="1" >0.00000000</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="2" >0.69999999</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="1" >0.00000000</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="2" >0.48461539</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="1" >0.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="2" >0.74615383</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="1" >0.00000000</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="2" >0.89230770</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="1" >0.00000000</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="2" >0.33076924</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="1" >0.00000000</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="2" >266.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="1" >0.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="2" >585.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="1" >0.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="2" >1287.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="1" >0.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="2" >110.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="1" >0.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="2" >242.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="1" >0.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="2" >532.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="1" >0.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="2" >1171.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="1" >0.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="2" >220.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="1" >0.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="2" >484.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="1" >0.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="2" >1064.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="1" >0.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="2" >55.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="1" >0.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="2" >2342.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="1" >55.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="4" >55.000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="1" >266.00000000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="4" >266.000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="1" >585.00000000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="4" >585.000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="1" >1287.00000000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="4" >1287.000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="1" >110.00000000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="4" >110.000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="1" >242.00000000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="4" >242.000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="1" >532.00000000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="4" >532.000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="1" >1171.00000000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="4" >1171.000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="1" >220.00000000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="4" >220.000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="1" >484.00000000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="4" >484.000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="1" >1064.00000000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="4" >1064.000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="1" >2342.00000000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="4" >2342.000</value>
<value id="{bf83e1da-fb92-4782-b291-79f2fadbc31b}" mode="1" >0.00100000</value>
<value id="{b29455b4-1f35-4da7-b6e3-1d26749f211b}" mode="1" >0.76024002</value>
<value id="{019ab94d-9192-4b84-9baa-480b3d8a287a}" mode="1" >1.15999997</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="1" >0.00100000</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="4" >0.001</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="1" >0.75999999</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="4" >0.760</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="1" >1.15999997</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="4" >1.160</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="1" >0.00000000</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="2" >0.05384615</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="1" >0.00000000</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="2" >0.14615385</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="1" >0.00000000</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="2" >0.23846154</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="1" >0.00000000</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="2" >0.23846154</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="1" >0.00000000</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="2" >440.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="1" >440.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="4" >440.000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="1" >0.00000000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="2" >968.00000000</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="1" >968.00000000</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="4" >968.000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="1" >0.00000000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="2" >2129.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="1" >2129.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="4" >2129.000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="1" >0.00000000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="2" >4685.00000000</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="1" >4685.00000000</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="4" >4685.000</value>
<value id="{43502468-8c8c-46ca-8860-9f9058bee7ba}" mode="1" >2.96025991</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="1" >2.96000004</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="4" >2.960</value>
<value id="{e9016c23-32cb-4e49-9796-4f759e833b0b}" mode="4" >0</value>
<value id="{81b9447d-4c7b-4fad-8809-d7b9627b0ebb}" mode="4" >0</value>
<value id="{41f5ac06-3b49-4566-809d-7a09abfc655e}" mode="1" >7.00000000</value>
<value id="{4bbe1673-18da-4fd2-b5c8-ca683b2e3264}" mode="1" >0.88999999</value>
<value id="{0997e946-6716-4b3e-9b85-c9d9f2dff660}" mode="1" >0.87000000</value>
<value id="{c9e7de4c-fd40-48e8-92fa-82dc416d3db4}" mode="1" >1.00000000</value>
<value id="{91ffa259-7ff9-46d2-bbbf-ed0be213a299}" mode="4" >0</value>
<value id="{652306da-467b-4488-9b99-fba18e1b5c12}" mode="4" >0</value>
<value id="{452a036d-c30b-4645-9052-1c73b35c16a0}" mode="4" >0</value>
<value id="{02ec4190-bca5-46ba-bc1e-215a1150bacc}" mode="4" >0</value>
<value id="{62bf5767-3df9-4e22-9156-64525155ee9b}" mode="4" >0</value>
</preset>
<preset name="Rhythm #03" number="12" >
<value id="{f7e4ef5f-b3b0-4a3b-9bed-fd4ea389a463}" mode="1" >0.66000003</value>
<value id="{90d3f87e-17d0-4384-bbe5-f9602bff0d7f}" mode="1" >0.69000000</value>
<value id="{1f2fbbe1-be05-43e9-a5fa-762b3b4a72e3}" mode="1" >0.87272727</value>
<value id="{374dbca9-a526-4d0e-b5e3-90478049b6bf}" mode="1" >0.77999997</value>
<value id="{056dbef4-8826-4d69-8e6a-852c4edc2ea8}" mode="1" >0.58999997</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="1" >0.00000000</value>
<value id="{2e7b10b9-5c75-4452-8cd2-1c44f8d30dd9}" mode="4" >0</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="1" >0.00000000</value>
<value id="{567bc827-d2f8-4b4e-b381-3ae13d4fb944}" mode="4" >0</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="1" >0.00000000</value>
<value id="{3c8b8066-5ea4-4c9b-a951-978582ea6fa9}" mode="4" >0</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="1" >1.00000000</value>
<value id="{b4443073-2b51-40c0-8fca-12617e9d2814}" mode="4" >1</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="1" >0.00000000</value>
<value id="{b74c7428-7e0a-4534-9721-84f928b784f0}" mode="4" >0</value>
<value id="{34836809-f2ae-40bf-83f4-70afd41e31d5}" mode="1" >1.00000000</value>
<value id="{1feef608-a361-4450-ab55-7696af9b3ae4}" mode="1" >2.00000000</value>
<value id="{c78a7996-cc03-400d-b5c3-0345e930d720}" mode="1" >8311.00000000</value>
<value id="{1e06ca5e-2c6b-411c-bd99-99abc366f3a3}" mode="1" >1387.00000000</value>
<value id="{b699fcb0-bc9f-4d8b-a372-78f618d3ba9b}" mode="1" >96.36000061</value>
<value id="{1ef1ea87-93e7-4b2b-9045-a146c9b13e0a}" mode="1" >1.00000000</value>
<value id="{2ee7e9c7-8b46-4c97-9f51-8439d355fdd1}" mode="4" >0</value>
<value id="{3dbe21c8-d134-48a2-a35d-06b231b2d800}" mode="1" >-255.00000000</value>
<value id="{e0b5676d-42d0-4f8b-9ddb-bbe5a8d899f1}" mode="1" >7.00000000</value>
<value id="{1fba5c43-d60e-49dc-8e1f-34467529754f}" mode="1" >1.05700004</value>
<value id="{57e07eec-f065-407f-bc8b-652ff42dd6da}" mode="1" >10.39999962</value>
<value id="{f4be3e35-886e-4424-96f9-a8caee28dace}" mode="1" >267.00000000</value>
<value id="{b3ef3a0a-66ab-472f-abe2-bbd7d19030ff}" mode="1" >267.00000000</value>
<value id="{e9d00afa-2d17-4143-aae7-0a9add2429a8}" mode="1" >350.00030518</value>
<value id="{f63e36a9-4510-4b12-bd82-62fa0686ba4f}" mode="1" >56.13000107</value>
<value id="{48dcad2d-eb3e-42a7-9793-ed2e19355426}" mode="1" >1387.00000000</value>
<value id="{6f061ce3-ab4b-4e1a-853f-42e97952075c}" mode="1" >8311.00000000</value>
<value id="{52f30728-cf31-43c5-abd5-9968e6f45bae}" mode="1" >10.39999962</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="1" >0.00000000</value>
<value id="{8fbfc604-cefd-40f0-978e-57c71d3aa42c}" mode="2" >0.93846154</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="1" >0.00000000</value>
<value id="{aa973b41-23db-4e4f-9890-2cb7530f2edf}" mode="2" >0.12307692</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="1" >0.00000000</value>
<value id="{ca2443b6-4419-45be-a836-472c81948c61}" mode="2" >0.33076924</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="1" >0.00000000</value>
<value id="{e8a03819-128d-45e0-b85e-cb6c6e89039b}" mode="2" >0.93846154</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="1" >0.00000000</value>
<value id="{152cb2a8-c7db-428c-8696-db6c7bf2fe6c}" mode="2" >0.43076923</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="1" >0.00000000</value>
<value id="{ed3ea933-b022-4420-b8ca-19950d71ccf5}" mode="2" >0.55384612</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="1" >0.00000000</value>
<value id="{ac312a98-f135-44cf-8ce3-ad847bf64347}" mode="2" >0.41538462</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="1" >0.00000000</value>
<value id="{b26dee23-b9c0-472c-9061-8460e6d93a16}" mode="2" >0.53076923</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="1" >0.00000000</value>
<value id="{7d3f5026-3f30-457e-9c95-fa7b198db30c}" mode="2" >0.93846154</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="1" >0.00000000</value>
<value id="{7a287fab-a25c-4bcc-97f4-589e7bc33815}" mode="2" >0.69999999</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="1" >0.00000000</value>
<value id="{82806551-10c5-4bf1-8fa7-f33f6187925d}" mode="2" >0.48461539</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="1" >0.00000000</value>
<value id="{6a641948-52e5-436a-a1a8-4d6e9624af58}" mode="2" >0.74615383</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="1" >0.00000000</value>
<value id="{37b6585f-0af0-4e2c-af4b-0c74deb8d87e}" mode="2" >0.89230770</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="1" >0.00000000</value>
<value id="{5aefaf87-d5c7-4192-963a-21dcc17ad71a}" mode="2" >0.33076924</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="1" >0.00000000</value>
<value id="{9c339096-fef3-491f-986b-d0713ce399fa}" mode="2" >266.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="1" >0.00000000</value>
<value id="{0f73a4dd-ade0-4cf8-9939-f488aa51ef40}" mode="2" >585.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="1" >0.00000000</value>
<value id="{5fb3e56b-eaa9-48cd-9a92-75c52be8cdaa}" mode="2" >1287.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="1" >0.00000000</value>
<value id="{e68a43a0-b80a-43a8-88b9-72f3ff8a6a5b}" mode="2" >110.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="1" >0.00000000</value>
<value id="{72b6ed4d-3606-48c4-887d-395c2e06460c}" mode="2" >242.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="1" >0.00000000</value>
<value id="{b7c64ddb-43b1-4c0d-8f93-281edb3fc7df}" mode="2" >532.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="1" >0.00000000</value>
<value id="{dbf73fa6-b5a3-41df-85cc-f8df5ff47e71}" mode="2" >1171.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="1" >0.00000000</value>
<value id="{6f99cab0-849b-4c31-a4ae-06202e4ee880}" mode="2" >220.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="1" >0.00000000</value>
<value id="{c3e6bbad-26c3-4ab0-ab1d-616793b7f920}" mode="2" >484.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="1" >0.00000000</value>
<value id="{382f8eab-c306-4ac0-8fb6-4a7467c55c22}" mode="2" >1064.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="1" >0.00000000</value>
<value id="{a96c0c23-3c18-4f99-b0b7-e8595a79ff14}" mode="2" >55.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="1" >0.00000000</value>
<value id="{9b16c998-3126-4e53-92a1-37e0c79ef4fa}" mode="2" >2342.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="1" >55.00000000</value>
<value id="{98189f56-ccdc-46d3-be8c-2f1b8dcb6aca}" mode="4" >55.000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="1" >266.00000000</value>
<value id="{af2791a7-0178-4cf1-8f49-b21f3434c8cd}" mode="4" >266.000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="1" >585.00000000</value>
<value id="{7d292521-72cb-4ae6-ba97-df1f42ff8343}" mode="4" >585.000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="1" >1287.00000000</value>
<value id="{ab7e1a64-b38b-47d2-86ea-7b728389ac5a}" mode="4" >1287.000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="1" >110.00000000</value>
<value id="{b3a1c166-05e7-41ff-9d68-cbadcd3db944}" mode="4" >110.000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="1" >242.00000000</value>
<value id="{6a9972e0-4af8-4660-a447-2ca723958d91}" mode="4" >242.000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="1" >532.00000000</value>
<value id="{31b0f180-920c-461b-a45d-4f3ae7721d52}" mode="4" >532.000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="1" >1171.00000000</value>
<value id="{18dd5e8a-380a-44ea-8d7f-d628047abfdc}" mode="4" >1171.000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="1" >220.00000000</value>
<value id="{d9d9dd3c-3f1e-46a0-8e9b-1ae6d521400a}" mode="4" >220.000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="1" >484.00000000</value>
<value id="{bb9d95c4-d9f6-43c0-b843-c1fc716e01e1}" mode="4" >484.000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="1" >1064.00000000</value>
<value id="{1716e36b-17ff-4d82-af74-74fdf8081999}" mode="4" >1064.000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="1" >2342.00000000</value>
<value id="{c4ed3184-82bb-4136-886d-023e39b38405}" mode="4" >2342.000</value>
<value id="{bf83e1da-fb92-4782-b291-79f2fadbc31b}" mode="1" >0.00100000</value>
<value id="{b29455b4-1f35-4da7-b6e3-1d26749f211b}" mode="1" >0.69933009</value>
<value id="{019ab94d-9192-4b84-9baa-480b3d8a287a}" mode="1" >1.15999997</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="1" >0.00100000</value>
<value id="{5b47c229-d87c-4754-9da0-ac04c61bf1cb}" mode="4" >0.001</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="1" >0.69933009</value>
<value id="{7d1ae936-c4df-435e-b54e-81868d9b0a63}" mode="4" >0.699</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="1" >1.15999997</value>
<value id="{3eb76da8-fb74-4ef5-b074-0e13106c122b}" mode="4" >1.160</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="1" >0.00000000</value>
<value id="{7df7694b-f289-49e1-a56a-a310756050d5}" mode="2" >0.05384615</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="1" >0.00000000</value>
<value id="{d61ce0f0-7d6e-4bd2-b9e7-4690b4281a05}" mode="2" >0.14615385</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="1" >0.00000000</value>
<value id="{43c2de00-77ce-4af4-98e4-e3b79e44e83f}" mode="2" >0.23846154</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="1" >0.00000000</value>
<value id="{da17ed9a-3cf6-498b-80e9-4dca2b07a681}" mode="2" >0.23846154</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="1" >0.00000000</value>
<value id="{91a5983c-29a5-4128-8744-9d2b1de044b8}" mode="2" >440.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="1" >440.00000000</value>
<value id="{40c35667-3c45-4aa9-b70e-61028d03ea5a}" mode="4" >440.000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="1" >0.00000000</value>
<value id="{f2568038-e70d-48e0-973a-88204d4d431c}" mode="2" >968.00000000</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="1" >968.00000000</value>
<value id="{cad9ff50-0f2a-450e-85eb-2f47f89d5612}" mode="4" >968.000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="1" >0.00000000</value>
<value id="{af25ea22-e30e-4ccc-a1b2-8a4a0141e472}" mode="2" >2129.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="1" >2129.00000000</value>
<value id="{73b0d183-960e-48fe-b7d8-5c2f5d75af0d}" mode="4" >2129.000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="1" >0.00000000</value>
<value id="{e504cab2-fd65-442e-988f-0fd968f8cab8}" mode="2" >4685.00000000</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="1" >4685.00000000</value>
<value id="{10b21f58-bdaf-49eb-a574-f732898fa8a4}" mode="4" >4685.000</value>
<value id="{43502468-8c8c-46ca-8860-9f9058bee7ba}" mode="1" >2.96025991</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="1" >2.96000004</value>
<value id="{9e767756-7162-485e-9d0d-74645a32c5ec}" mode="4" >2.960</value>
<value id="{e9016c23-32cb-4e49-9796-4f759e833b0b}" mode="4" >0</value>
<value id="{81b9447d-4c7b-4fad-8809-d7b9627b0ebb}" mode="4" >0</value>
<value id="{41f5ac06-3b49-4566-809d-7a09abfc655e}" mode="1" >7.00000000</value>
<value id="{4bbe1673-18da-4fd2-b5c8-ca683b2e3264}" mode="1" >0.00000000</value>
<value id="{0997e946-6716-4b3e-9b85-c9d9f2dff660}" mode="1" >0.87000000</value>
<value id="{c9e7de4c-fd40-48e8-92fa-82dc416d3db4}" mode="1" >1.00000000</value>
<value id="{91ffa259-7ff9-46d2-bbbf-ed0be213a299}" mode="4" >0</value>
<value id="{652306da-467b-4488-9b99-fba18e1b5c12}" mode="4" >0</value>
<value id="{452a036d-c30b-4645-9052-1c73b35c16a0}" mode="4" >0</value>
<value id="{02ec4190-bca5-46ba-bc1e-215a1150bacc}" mode="4" >0</value>
<value id="{62bf5767-3df9-4e22-9156-64525155ee9b}" mode="4" >0</value>
</preset>
</bsbPresets>
