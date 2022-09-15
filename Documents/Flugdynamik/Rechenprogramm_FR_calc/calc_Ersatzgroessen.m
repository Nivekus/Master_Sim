%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Technische Universität Berlin - Fakultät V                              %
% Institut für Luft- und Raumfahrttechnik                                 %
% Fachgebiet Flugmechanik, Flugregelung und Aeroelastizität               %
% Prof. Dr.-Ing. Robert Luckner                                           %
%                                                                         %
% Projektname:      FR_calc - Berechnungstool für das Buch Flugregelung   %
% Datei:            calc_Ersatzgroessen.m                                 %
% Zweck:            Berechnung der Ersatzgrößen                           %
%                                                                         %
% Autoren:          Prof. Dr.-Ing. Robert Luckner                         %  
%                   Dipl.-Ing. Andrej Schönfeld                           %
%                   Alexander Köthe, B.Sc.                                %
%                   cand.-Ing. Fadi Bitar                                 %
%                                                                         %
% Version :         1.0                                                   %
% Datum   :         28.10.2011                                            %
%                                                                         %
%_________________________________________________________________________%
%                                                                         %
% Revisionen                                                              %
% ----------                                                              %
% Nr.  Datum     Autor          Änderung                                  %
% ---  --------  -------------  ---------------------------------------   %
%                                                                         %
%_________________________________________________________________________%
%                                                                         %
% Alle Daten in SI-Einheiten, Winkel werden in Grad ein- und ausgegeben,  %
% müssen aber programmintern in das Bogenmaß umgerechnet werden           %
%                                                                         %
% externe Variable                                                        %
% ----------------                                                        %
% Eingangsgrößen:  Fall           - Bewegungsform                         %
%                  AC             - Flugzeugdaten                         %
%                  FZ             - Flugzstandsparameter                  % 
% Ausgangsgrößen:  Ersatzgroessen - Ersatzgrößen                          %
%                                                                         %
%_________________________________________________________________________%
%                                                                         %
% interne Variable                                                        %
% ----------------                                                        %
%               Bezeichnung im Buch                                       %
% Matlab        (TeX-Rohformat)       Bedeutung                           %
% -------       ------------------    ----------------------------------- %
% qq            q                     Staudruck                           %
% g             g                     Erdbeschleunigung                   %
% S             S                     Flügelfläche                        %
% b             b                     Spannweite                          %
% s             s                     Halbspannweite                      %
% lmy           \overline{c}          mittlere Flügeltiefe                %
% zf            z_f                   z- Komponente des Abstand vom       %
%                                     Triebwerk zum Flugzeugschwerkpunkt  %
% iff           i_F                   Schubeinbauwinkel                   %
% Fmax          F_{max}               maximaler Schub                     %
% m             m                     Flugzeugmasse                       %
% Ix            I_x                   Massenträgheitsmoment um die x-Achse%
% Iy            I_y                   Massenträgheitsmoment um die y-Achse%
% Iz            I_z                   Massenträgheitsmoment um die z-Achse%
% Ixz           I_{xz}                Deviationsmoment um die x,z Ebene   %
% Ma            M                     Machzahl                            %
% H             H                     Höhe                                %
% rho           \rho                  Dichte                              %
% a             a                     Schallgeschwindigkeit               %
% ga_r          \gamma_0              Referenzbahnwinkel                  %
% al_r          \alpha_0              Referenzanstellwinkel               %
% F             F                     Schub                               %
% dF_dM         \frac{\partial F}     Änderung des Schubes infolge einer  %
%               {\partial M}          Änderung der Machzahl               %
% C_Ar          C_{A0}                Nullauftriebsbeiwert                %
% C_Aal         C_{A\alpha}           Auftriebsanstieg                    %
% C_Aalp´       C_{A\dot{\alpha}}     Auftriebbeiwertes infolge           %
%                                     einer Anstellwinkelveränderung      %
% C_Aq          C_{Aq}                Auftriebbeiwert infolge der Nickrate%
% C_AM          C_{AM}                Auftriebbeiwert infolge der Machzahl%
% C_Aet         C_{A\eta}             Auftriebbeiwert infolge eines       %
%                                     Höhenruderausschlags                %
% C_Wr          C_{W0}                Nullwiderstandsbeiwert              %
% C_Wal         C_{W\alpha}           Widerstandbeiwert infolge eines     %
%                                     Anstellwinkels                      %
% C_Walp        C_{W\dot{\alpha}}     Widerstandbeiwert infolge einer     %
%                                     Änderung des Anstellwinkels         %
% C_Wq          C_{Wq}                Widerstandbeiwert infolge einer     %
%                                     Nickrate                            %                 
% C_WM          C_{WM}                Widerstandbeiwert infolge der       %
%                                     Machzahl                            %
% C_Wet    		C_{W\eta}             Widerstandbeiwert infolge eines     %
%               	                  Höhenruderausschlags                %
% C_Wka    		C_{W\kappa}           Widerstandbeiwert infolge eines     %
%               	                  Klappenausschlags                   %
% C_mr     		C_{m0}                Nullmomentenbeiwert                 %
% C_mal    		C_{m\alpha}           Nickmomentenbeiwert infolges des    %
%               	                  Anstellwinkels                      %
% C_malp   		C_{m\dot{\alpha}}     Nickmomentenbeiwert infolges der    %
%               	                  Änderung des Anstellwinkels         %
% C_mq     		C_{mq}                Nickmomentenbeiwert infolges einer  %
%               	                  Drehrate (Nickdämpfung)             %
% C_mM     		C_{mM}                Nickmomentenbeiwert infolges der    %
%               	                  Machzahl                            %
% C_met    		C_{m\eta}             Nickmomentenbeiwert infolges eines  %
%                	                  Höhenruderausschlags                %
% C_mka    		C_{m\kappa}           Nickmomentenbeiwert infolges eines  %
%               	                  Klappenausschlags                   %
% C_Qbe    		C_{Q\beta}            Querkraftbeiwert infolge Schieben   %
% C_Qp     		C_{Qp}                Querkraftbeiwert infolge Rollen     %
% C_Qr     		C_{Qr}                Querkraftbeiwert infolge Gieren     %
% C_Qxi    		C_{Q\xi}              Querkraftbeiwert infolge            %
%              		                  eines Querruderausschlags           %
% C_Qze    		C_{Q\zeta}            Querkraftbeiwert infolge            %
%              		                  Seitenruderausschlags               %
% C_lbe    		C_{l\beta}            Rollmomentenbeiwert infolge Schieben%
% C_lp     		C_{lp}                Rollmomentenbeiwert infolge Rollen  %
% C_lr     		C_{lr}                Rollmomentenbeiwert infolge Gieren  %
% C_lxi    		C_{l\xi}              Rollmomentenbeiwert infolge         %
%                    	              eines Querruderausschlags           %
% C_lze    		C_{l\zeta}            Rollmomentenbeiwert infolge         %
%               	                  Seitenruderausschlags               %
% C_nbe    		C_{n\beta}            Giermomentenbeiwert infolge Schieben%
% C_np     		C_{np}                Giermomentenbeiwert infolge Rollen  %
% C_nr     		C_{nr}                Giermomentenbeiwert infolge Gieren  %
% C_nxi    		C_{n\xi}              Giermomentenbeiwert infolge         %
%               	                  eines Querruderausschlags           %
% C_nze    		C_{n\zeta}            Giermomentenbeiwert infolge         %
%               	                  Seitenruderausschlags               %
% Mq            M_q                   Nickmoment infolge einer Nickrate   %
% Mal           M_{\alpha}            Nickmoment infolge eines Anstell-   %
%                                     winkels                             %
% Mu            M_u                   Nickmoment infolge der Geschwin-    %
%                                     digkeit in x- Richtung              %
% Zal           Z_{\alpha}            Kraft in z- Richtung infolge eines  %
%                                     Anstellwinkels                      %
% Zthe          Z_{\Theta}            Kraft in z- Richtung infolge eines  %
%                                     Längslagewinkels                    %
% Zu            Z_u                   Kraft in z- Richtung infolge einer  %
%                                     Geschwindigkeit in x-Richtung       %
% Xal           X_{\alpha}            Kraft in x- Richtung infolge eines  %
%                                     Anstellwinkels                      %
% Xthe          X_{\Theta}            Kraft in x- Richtung infolge eines  %
%                                     Längslagewinkels                    %
% Xu            X_u                   Kraft in x- Richtung infolge einer  %
%                                     Geschwindigkeit in x-Richtung       %
% Mf            M_f                   Nickmoment infolge des Schubes      %
% Mkap          M_{\kappa}            Nickmoment infolge eines Klappen-   %
%                                     ausschlages                         %
% Met           M_{\eta}              Nickmoment infolge eines Höhenru-   %
%                                     derausschlages                      %
% Xf            X_f                   Kraft in x-Richtung infolge des     %
%                                     Schubes                             %
% Xkap          X_{\kappa}            Kraft in x-Richtung infolge eines   %
%                                     Klappenausschlages                  %
% Xet           X_{\eta}              Kraft in x-Richtung infolge eines   %
%                                     Höhenruderausschlages               %
% Zf            Z_f                   Kraft in z-Richtung infolge des     %
%                                     Schubes                             %
% Zkap          Z_{\kappa}            Kraft in z-Richtung infolge eines   %
%                                     Klappenausschlages                  %
% Zet           Z_{\eta}              Kraft in z-Richtung infolge eines   %
%                                     Höhenruderausschlages               %
% Nbet          N_{\beta}             Giermoment infolge eines Schiebe-   %
%                                     winkels                             %
% Nr            N_r                   Giermoment infolge einer Gierrate   %
% Ybet          Y_{\beta}             Querkraft infolge eines Schiebe-    %
%                                     winkels                             %
% Lbet          L_{\beta}             Rollmoment infolge eines Schiebe-   %
%                                     winkels                             %
% Lr            L_r                   Rollmoment infolge einer Gierrate   %
% Nxi           L_{\xi}               Giermoment infolge eines Querruder- %
%                                     ausschlages                         %
% Nzeta         L_{\zeta}             Giermoment infolge eines Seiten-    %
%                                     ruderausschlages                    %
% Lxi           L_{\xi}               Rollmoment infolge eines Querruder- %
%                                     ausschlages                         %
% Lzeta         L_{\zeta}             Rollmoment infolge eines Seiten-    %
%                                     ruderausschlages                    %
% al_r          \alpha_R              Referenzanstellwinkel               %
% ga_r          \gamma_R              Referenzbahnneigungswinkel          %
% V_r           V_R                   Referenzgeschwindigkeit             %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


%% Hauptfunktion

function Ersatzgroessen = calc_Ersatzgroessen(Fall,AC,FZ)

%% Fallunterscheidung, welchen Bewegungsform vorliegt

if (Fall == 1)
    % Längsbewegung
    Ersatzgroessen = ErsatzgroessenLB(AC,FZ);
elseif (Fall == 2)
    % Seitenbewegung
    Ersatzgroessen = ErsatzgroessenSB(AC,FZ);
else
    % Fehlerfall
    Ersatzgroessen = 0;
end
end

%% Funktion zur Ermittelung der Ersatzgrößen in der Längsbewegung

function ErsatzgroessenLB = ErsatzgroessenLB(AC,FZ)

% Bestimmung des Staudrucks und der Erdbeschleunigung
qq = FZ.rho/2 * FZ.V_r^2;
g  = 9.80665;

% Ersatzgrößen der Kräfte in X- Richtung (Widerstand)
ErsatzgroessenLB.Xu     = - qq * AC.S/AC.m * (((2/FZ.V_r) * FZ.C_Wr + (1/FZ.a) * FZ.C_WM) - FZ.al_r * ((2/FZ.V_r) * FZ.C_Ar + (1/FZ.a) * FZ.C_AM)) + (1/FZ.a/AC.m * FZ.dF_dM);
ErsatzgroessenLB.Xal    = - qq * AC.S/AC.m * (FZ.C_Wal  - FZ.C_Ar - FZ.al_r * FZ.C_Aal);
ErsatzgroessenLB.Xalp   = - qq * AC.S/AC.m * (FZ.C_Walp - FZ.al_r * FZ.C_Aalp) * AC.lmy / FZ.V_r;
ErsatzgroessenLB.Xq     = - qq * AC.S/AC.m * (FZ.C_Wq   - FZ.al_r * FZ.C_Aq)   * AC.lmy / FZ.V_r;
ErsatzgroessenLB.Xthe   = - g;
ErsatzgroessenLB.Xeta   = - qq * AC.S/AC.m * (FZ.C_Wet - FZ.al_r * FZ.C_Aet);
ErsatzgroessenLB.Xf     =   AC.Fmax / AC.m;
ErsatzgroessenLB.Xkap   = - qq * AC.S/AC.m * (FZ.C_Wka - FZ.al_r * FZ.C_Aka);

% Ersatzgrößen der Kräfte in Z- Richtung (Auftrieb)
ErsatzgroessenLB.Zu     = - qq * AC.S/AC.m/FZ.V_r * ((2/FZ.V_r * FZ.C_Ar + 1/FZ.a * FZ.C_AM) + FZ.al_r * (2/FZ.V_r * FZ.C_Wr + 1/FZ.a * FZ.C_WM)) + AC.iff/FZ.a/AC.m * FZ.dF_dM;
ErsatzgroessenLB.Zal    = - qq * AC.S/AC.m/FZ.V_r * (FZ.C_Aal + FZ.C_Wr + FZ.al_r * FZ.C_Wal);
ErsatzgroessenLB.Zalp   = - qq * AC.S/AC.m/FZ.V_r * AC.lmy / FZ.V_r * (AC.lmy/FZ.V_r) * (FZ.C_Aalp + FZ.al_r * FZ.C_Walp);
ErsatzgroessenLB.Zq     = - qq * AC.S/AC.m/FZ.V_r * AC.lmy / FZ.V_r * (FZ.C_Aq - FZ.al_r * FZ.C_Wq);
ErsatzgroessenLB.Zthe   = - g /FZ.V_r * (FZ.al_r + FZ.ga_r);
ErsatzgroessenLB.Zeta   = - qq * AC.S/AC.m/FZ.V_r * (FZ.C_Aet + FZ.al_r * FZ.C_Wet);
ErsatzgroessenLB.Zf     = - AC.iff/FZ.V_r * AC.Fmax / AC.m;
ErsatzgroessenLB.Zkap   = - qq * AC.S/AC.m/FZ.V_r * (FZ.C_Aka + FZ.al_r * FZ.C_Wka);

% Ersatzgrößen der Momente um die Y- Achse (Nicken)
ErsatzgroessenLB.Mu     = qq * AC.S * AC.lmy / AC.Iy * (2/FZ.V_r * FZ.C_mr + 1/FZ.a * FZ.C_mM) + AC.zf / FZ.a / AC.Iy * FZ.dF_dM;
ErsatzgroessenLB.Mal    = qq * AC.S * AC.lmy / AC.Iy * FZ.C_mal;
ErsatzgroessenLB.Malp   = qq * AC.S * AC.lmy / AC.Iy * FZ.C_malp * AC.lmy / FZ.V_r;
ErsatzgroessenLB.Mqs    = qq * AC.S * AC.lmy / AC.Iy * FZ.C_mq   * AC.lmy / FZ.V_r;
ErsatzgroessenLB.Meta   = qq * AC.S * AC.lmy / AC.Iy * FZ.C_met;
ErsatzgroessenLB.Mf     = AC.zf / AC.Iy * AC.Fmax;
ErsatzgroessenLB.Mkap   = qq * AC.S * AC.lmy / AC.Iy * FZ.C_mka;
ErsatzgroessenLB.Mq     = ErsatzgroessenLB.Mqs + ErsatzgroessenLB.Malp;
ErsatzgroessenLB.MWx    = ErsatzgroessenLB.Mqs - ErsatzgroessenLB.Malp;
end

function ErsatzgroessenSB = ErsatzgroessenSB(AC,FZ)

% Bestimmung des Staudrucks und der Erdbeschleunigung
qq = FZ.rho/2 * FZ.V_r^2;
g  = 9.80665;

% Ersatzgrößen der Kräfte in Y- Richtung (Querkraft)
ErsatzgroessenSB.Ybet   = qq * AC.S / AC.m / FZ.V_r * FZ.C_Qbe;
ErsatzgroessenSB.Ybetp  = qq * AC.S / AC.m / FZ.V_r * FZ.C_Qbep * AC.b / 2 / FZ.V_r;
ErsatzgroessenSB.Yp     = qq * AC.S / AC.m / FZ.V_r * FZ.C_Qp   * AC.b / 2 / FZ.V_r;
ErsatzgroessenSB.Yr     = qq * AC.S / AC.m / FZ.V_r * FZ.C_Qr   * AC.b / 2 / FZ.V_r;
ErsatzgroessenSB.Yxi    = qq * AC.S / AC.m / FZ.V_r * FZ.C_Qxi;
ErsatzgroessenSB.Yzeta  = qq * AC.S / AC.m / FZ.V_r * FZ.C_Qze;

% Ersatzgrößen der Momente um die X- Achse (Rollen)
ErsatzgroessenSB.Lbet   = qq * AC.S * AC.b / 2 / AC.del * (AC.Iz * FZ.C_lbe  + AC.Ixz * FZ.C_nbe);
ErsatzgroessenSB.Lbetp  = qq * AC.S * AC.b / 2 / AC.del * (AC.Iz * FZ.C_lbep + AC.Ixz * FZ.C_nbep) * AC.b / 2 / FZ.V_r;
ErsatzgroessenSB.Lp     = qq * AC.S * AC.b / 2 / AC.del * (AC.Iz * FZ.C_lp   + AC.Ixz * FZ.C_np)   * AC.b / 2 / FZ.V_r;
ErsatzgroessenSB.Lr     = qq * AC.S * AC.b / 2 / AC.del * (AC.Iz * FZ.C_lr   + AC.Ixz * FZ.C_nr)   * AC.b / 2 / FZ.V_r;
ErsatzgroessenSB.Lxi    = qq * AC.S * AC.b / 2 / AC.del * (AC.Iz * FZ.C_lxi  + AC.Ixz * FZ.C_nxi);
ErsatzgroessenSB.Lzeta  = qq * AC.S * AC.b / 2 / AC.del * (AC.Iz * FZ.C_lze  + AC.Ixz * FZ.C_nze);

% Ersatzgrößen der Momente um die Z- Achse (Gieren)
ErsatzgroessenSB.Nbet   = qq * AC.S * AC.b / 2 / AC.del * (AC.Ix * FZ.C_nbe  + AC.Ixz * FZ.C_lbe);
ErsatzgroessenSB.Nbetp  = qq * AC.S * AC.b / 2 / AC.del * (AC.Ix * FZ.C_nbep + AC.Ixz * FZ.C_lbep) * AC.b / 2 / FZ.V_r;
ErsatzgroessenSB.Np     = qq * AC.S * AC.b / 2 / AC.del * (AC.Ix * FZ.C_np   + AC.Ixz * FZ.C_lp)   * AC.b / 2 / FZ.V_r;
ErsatzgroessenSB.Nr     = qq * AC.S * AC.b / 2 / AC.del * (AC.Ix * FZ.C_nr   + AC.Ixz * FZ.C_lr)   * AC.b / 2 / FZ.V_r;
ErsatzgroessenSB.Nxi    = qq * AC.S * AC.b / 2 / AC.del * (AC.Ix * FZ.C_nxi  + AC.Ixz * FZ.C_lxi);
ErsatzgroessenSB.Nzeta  = qq * AC.S * AC.b / 2 / AC.del * (AC.Ix * FZ.C_nze  + AC.Ixz * FZ.C_lze);
end
