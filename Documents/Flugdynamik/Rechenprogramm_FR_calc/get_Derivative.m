%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Technische Universität Berlin - Fakultät V                              %
% Institut für Luft- und Raumfahrttechnik                                 %
% Fachgebiet Flugmechanik, Flugregelung und Aeroelastizität               %
% Prof. Dr.-Ing. Robert Luckner                                           %
%                                                                         %
% Projektname:      FR_calc - Berechnungstool für das Buch Flugregelung   %
% Datei:            get_Derivative.m                                      %
% Zweck:            Enthält alls Flugzeug- und Zustandsaten               %
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
% Eingangsgrößen:  keine                                                  %
% Ausgangsgrößen:  AC  - Struktur mit den Flugzeugdaten                   %
%                  FZ  - Struktur mit den Flugzstandsdaten                %
%                                                                         %
%_________________________________________________________________________%
%                                                                         %
% interne Variable                                                        %
% ----------------                                                        %
%          Bezeichnung im Buch                                            %
% Matlab   (TeX-Rohformat)       Bedeutung                                %
% -------  ------------------    --------------------------------------   %
% S        S                     Flügelfläche                             %
% b        b                     Spannweite                               %
% s        s                     Halbspannweite                           %
% lmy      \overline{c}          mittlere Flügeltiefe                     %
% zf       z_f                   z-Komponente des Abstand vom             %
%                                Triebwerk zum Flugzeugschwerkpunkt       %
% iff      i_F                   Schubeinbauwinkel                        %
% Fmax     F_{max}               maximaler Schub                          %
% m        m                     Flugzeugmasse                            %
% Ix       I_x                   Massenträgheitsmoment um die x-Achse     %
% Iy       I_y                   Massenträgheitsmoment um die y-Achse     %
% Iz       I_z                   Massenträgheitsmoment um die z-Achse     %
% Ixz      I_{xz}                Deviationsmoment um die x,z Ebene        %
% V_r      V_A                   Referenzgeschwindigkit                   %
% Ma       M                     Machzahl                                 %
% H        H                     Höhe                                     %
% rho      \rho                  Dichte                                   %
% a        a                     Schallgeschwindigkeit                    %
% ga_r     \gamma_0              Referenzbahnwinkel                       %
% al_r     \alpha_0              Referenzanstellwinkel                    %
% F        F                     Schub                                    %
% dF_dM    \frac{\partial F}     Änderung des Schubes infolge einer       %
%          {\partial M}          Änderung der Machzahl                    %
% C_Ar     C_{A0}                Nullauftriebsbeiwert                     %
% C_Aal    C_{A\alpha}           Auftriebsanstieg                         %
% C_Aalp´  C_{A\dot{\alpha}}     Auftriebbeiwertes infolge                %
%                                einer Anstellwinkelveränderung           %
% C_Aq     C_{Aq}                Auftriebbeiwert infolge der Nickrate     %
% C_AM     C_{AM}                Auftriebbeiwert infolge der Machzahl     %
% C_Aet    C_{A\eta}             Auftriebbeiwert infolge eines            %
%                                Höhenruderausschlags                     %
% C_Wr     C_{W0}                Nullwiderstandsbeiwert                   %
% C_Wal    C_{W\alpha}           Widerstandbeiwert infolge eines          %
%                                Anstellwinkels                           %
% C_Walp   C_{W\dot{\alpha}}     Widerstandbeiwert infolge einer          %
%                                Änderung des Anstellwinkels              %
% C_Wq     C_{Wq}                Widerstandbeiwert infolge einer          %
%                                Nickrate                                 %                 
% C_WM     C_{WM}                Widerstandbeiwert infolge der Machzahl   %
% C_Wet    C_{W\eta}             Widerstandbeiwert infolge eines          %
%                                Höhenruderausschlags                     %
% C_Wka    C_{W\kappa}           Widerstandbeiwert infolge eines          %
%                                Klappenausschlags                        %
% C_mr     C_{m0}                Nullmomentenbeiwert                      %
% C_mal    C_{m\alpha}           Nickmomentenbeiwert infolges des         %
%                                Anstellwinkels                           %
% C_malp   C_{m\dot{\alpha}}     Nickmomentenbeiwert infolges der         %
%                                Änderung des Anstellwinkels              %
% C_mq     C_{mq}                Nickmomentenbeiwert infolges einer       %
%                                Drehrate (Nickdämpfung)                  %
% C_mM     C_{mM}                Nickmomentenbeiwert infolges der         %
%                                Machzahl                                 %
% C_met    C_{m\eta}             Nickmomentenbeiwert infolges eines       %
%                                Höhenruderausschlags                     %
% C_mka    C_{m\kappa}           Nickmomentenbeiwert infolges eines       %
%                                Klappenausschlags                        %
% C_Qbe    C_{Q\beta}            Querkraftbeiwert infolge Schieben        %
% C_Qp     C_{Qp}                Querkraftbeiwert infolge Rollen          %
% C_Qr     C_{Qr}                Querkraftbeiwert infolge Gieren          %
% C_Qxi    C_{Q\xi}              Querkraftbeiwert infolge                 %
%                                eines Querruderausschlags                %
% C_Qze    C_{Q\zeta}            Querkraftbeiwert infolge                 %
%                                Seitenruderausschlags                    %
% C_lbe    C_{l\beta}            Rollmomentenbeiwert infolge Schieben     %
% C_lp     C_{lp}                Rollmomentenbeiwert infolge Rollen       %
% C_lr     C_{lr}                Rollmomentenbeiwert infolge Gieren       %
% C_lxi    C_{l\xi}              Rollmomentenbeiwert infolge              %
%                                eines Querruderausschlags                %
% C_lze    C_{l\zeta}            Rollmomentenbeiwert infolge              %
%                                Seitenruderausschlags                    %
% C_nbe    C_{n\beta}            Giermomentenbeiwert infolge Schieben     %
% C_np     C_{np}                Giermomentenbeiwert infolge Rollen       %
% C_nr     C_{nr}                Giermomentenbeiwert infolge Gieren       %
% C_nxi    C_{n\xi}              Giermomentenbeiwert infolge              %
%                                eines Querruderausschlags                %
% C_nze    C_{n\zeta}            Giermomentenbeiwert infolge              %
%                                Seitenruderausschlags                    %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Konstante
deg2rad = pi / 180;
rad2deg = 180 / pi;


%% Definition der Flugzeuge
% Die Struktur AC enthält den Namen des Flugzeugs sowie konstante
% Kenngrößen. Die Struktur selbst ist als Array angelegt, dabei entspricht
%   AC(1)  =   Airbus A300
%   AC(2)  =   Beoing 707
%   AC(3)  =   Concorde
%   AC(4)  =   Do328
%   AC(5)  =   Lockheed F104G

% Airbus A300
AC(1).Name =                   'Airbus A300';
AC(1).S    =                             260;
AC(1).b    =                            44.8;
AC(1). s   =                     0.5*AC(1).b;
AC(1).lmy  =                             6.6;
AC(1).zf   =                            2.65;
AC(1).iff  =                    deg2rad*2.17;
AC(1).Fmax =                          452000;
AC(1).m    =                          130000;
AC(1).Ix   =                         6011000;
AC(1).Iy   =                        10530000;
AC(1).Iz   =                        15730000;
AC(1).Ixz  =                          330000;
AC(1).del  =   AC(1).Ix*AC(1).Iz-AC(1).Ixz^2;

% Boeing 707
AC(2).Name =                    'Boeing 707';
AC(2).S    =                             268;
AC(2).b    =                            43.4;
AC(2).s    =                     0.5*AC(2).b;
AC(2).lmy  =                            6.39;
AC(2).zf   =                            -1.5;
AC(2).iff  =                     deg2rad*0.0;
AC(2).Fmax =                          320800;
AC(2).m    =                          100000;
AC(2).Ix   =                         5030000;
AC(2).Iy   =                         6870000;
AC(2).Iz   =                        12260000;
AC(2).Ixz  =                               0;
AC(2).del  =   AC(2).Ix*AC(2).Iz-AC(2).Ixz^2;

% Concorde
AC(3).Name =                      'Concorde';
AC(3).S    =                           358.6;
AC(3).b    =                            25.6;
AC(3).s    =                     0.5*AC(3).b;
AC(3).lmy  =                            27.5;
AC(3).zf   =                             0.7; 
AC(3).iff  =                     deg2rad*0.0;
AC(3).Fmax =                          676000;
AC(3).m    =                          150000;
AC(3).Ix   =                         2166000;
AC(3).Iy   =                        18150000;
AC(3).Iz   =                        19840000;
AC(3).Ixz  =                               0;
AC(3).del  =   AC(3).Ix*AC(3).Iz-AC(3).Ixz^2;

% Dornier Do 328
AC(4).Name =                'Dornier Do 328';
AC(4).S    =                            40.0;
AC(4).b    =                            20.8;
AC(4).s    =                     0.5*AC(4).b;
AC(4).lmy  =                            2.04;
AC(4).zf   =                           -0.55; 
AC(4).iff  =                    deg2rad*-1.5;
AC(4).Fmax =                           27350;
AC(4).m    =                           10500;
AC(4).Ix   =                          103000;
AC(4).Iy   =                          158000;
AC(4).Iz   =                          240000;
AC(4).Ixz  =                           12500;
AC(4).del  =   AC(4).Ix*AC(4).Iz-AC(4).Ixz^2;

% Lockheed F104G
AC(5).Name =                'Lockheed F104G';
AC(5).S    =                            18.2;
AC(5).b    =                            13.4;
AC(5).s    =                     0.5*AC(5).b;
AC(5).lmy  =                            2.91;
AC(5).zf   =                             0.0; 
AC(5).iff  =                     deg2rad*0.0;
AC(5).Fmax =                           70600;
AC(5).m    =                            7394;
AC(5).Ix   =                            4990;
AC(5).Iy   =                           79470;
AC(5).Iz   =                           80720;
AC(5).Ixz  =                            3640;
AC(5).del  =   AC(5).Ix*AC(5).Iz-AC(5).Ixz^2;

%% Definition der Flugzustände
% Die Zustandsgrößen werden für jeden Flugzustand in
% Vektoren abgelegt. Die Zuordnung zwischen Eintrag und Vektorelement
% geschieht folgendermaßen
%
% 1  -   A1  - Landeanflug A300
% 2  -   A2  - Warteflug A300
% 3  -   A3  - Reiseflug A300
% 4  -   B1  - Landeanflug Boeing 707 (Fahrwerk ausgefahren)
% 5  -   B2  - Warteflug Boeing 707
% 6  -   B3  - Reiseflug Boeing 707
% 7  -   C1  - Landeanflug Concorde
% 8  -   C2  - Unterschall-Reiseflug Concorde
% 9  -   C3  - Überschall-Reiseflug Concorde
% 10 -   D1  - Landeanflug Do 328 (Fahrwerk ausgefahren)
% 11 -   D2  - Steigflug  Do 328
% 12 -   D3  - Reiseflug  Do 328
% 13 -   F1  - Landeanflug Lockheed F104G (Fahrwerk ausgefahren)
% 14 -   F2  - Schnellflug in Bodennähe Lockheed F104G
% 15 -   F3  - Reiseflug Lockheed F104G

%                        A1      A2      A3      B1     B2       B3      C1      C2      C3      D1      D2      D3      F1      F2      F3      
V_r   =            [     77   131.5     264      80    130      240     84.8    268     570      53     103     144    87.5     374     590];
Ma    =            [  0.228     0.4   0.881   0.235  0.390    0.801    0.251  0.882    2.07   0.156   0.303   0.428   0.257     1.1       2];
H     =            [    600    3000   10000     100   1500    10000     600    9000   15500     300     300     900     100     100   13700];
rho   =            [ 1.1560  0.9091  0.4127   1.225 1.0581   0.4127   1.156  0.4663  0.1795  1.1896  1.1896   1.121   1.225   1.225  0.2460];
a     =            [340.429 328.709 299.853 340.492 334.62  299.853 340.429 303.915 295.188 340.429 340.429 336.576 340.429 340.429 295.188];
al_r  =  deg2rad * [   7.84     4.0       0       4    1.2     -1.5   17.96    5.95    4.63    1.82    2.04    0.16     2.3       1       3];
ga_r  =  deg2rad * [     -3       0       0      -3      0        0      -3       0       0      -3       3       0      -3       0       0];
F     =            [  79033   75677   85972   75340  44440    73280  250130  136080  205000       0       0       0   22650   73580   31590];
dF_dM =            [      0       0       0       0      0        0       0       0       0       0       0       0       0       0       0];

%% Derivative der Längsbewegung
% Die Derivative der Längsbewegung werden in gleicher Weise wie die
% Flugzustände in Vektoren abgelegt.
%
%            A1      A2      A3      B1      B2      B3      C1      C2      C3      D1      D2      D3      F1      F2      F3
C_Ar   = [  1.417   0.621   0.341   0.937   0.376   0.239   0.934   0.243   0.127   1.536   0.408   0.221   0.735   0.045   0.093];
C_Aal  = [  5.66    4.72    6.22    3.72    3.83    4.60    3.38    3.07    1.95    6.76    5.98    6.00    3.44    5.00    2.50];
C_Aalp = [  1.00    1.10    1.55    0.00    0.00    0.00    0.00    0.00    0.00    1.53    0.929   0.907   0.00    0.00    0.00];
C_Aq   = [  3.20    3.50    3.80    0.00    0.00    0.00    0.669   1.143   1.236   4.39    4.39    4.39    0.00    0.00    0.00];
C_AM   = [  0.00    0.00    0.00   -0.133  -0.117   0.064   0.00    0.200  -0.100   0.00    0.00    0.00    0.00   -0.04   -0.08];
C_Aet  = [  0.433   0.395   0.194   0.228   0.215   0.189   0.804   0.944   0.152   0.349   0.349   0.349   0.68    0.6     0.4];
C_Aka  = [  0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00]; 
C_Wr   = [  0.163   0.0369  0.023   0.172   0.021   0.018   0.211   0.0225  0.0179  0.069   0.049   0.027   0.263   0.047   0.044];
C_Wal  = [  0.814   0.302   0.219   0.359   0.103   0.103   2.03    0.476   0.202   0.478   0.072  -0.002   0.45    0.08    0.16];
C_Walp = [  0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00];
C_Wq   = [  0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00];
C_WM   = [  0.00    0.00    0.00    0.00    0.00    0.020  -0.002  -0.007   0.002   0.00    0.00    0.00    0.00    0.03    0.00];
C_Wet  = [  0.0623  0.0253  0.0068 -0.011  -0.011  -0.011   0.482   0.146   0.0158  0.00    0.00    0.00    0.00    0.00    0.00];
C_Wka  = [  0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00];
C_mr   = [ -0.0356 -0.0149 -0.0092 -0.095   0.049   0.070  -0.0043  0.0006 -0.0005  0.092   0.104   0.127   0.00    0.00    0.00];
C_mal  = [ -1.203  -0.747  -1.081  -0.680  -0.622  -0.824  -0.0437 -0.0697 -0.1067 -1.696  -1.549  -1.678  -0.64   -1.8    -0.8];
C_malp = [ -5.21   -5.25   -8.65   -3.01   -2.95   -3.63    0.00    0.00    0.00   -8.64   -5.26   -5.141  -0.8    -1.7    -1.4];
C_mq   = [-13.61  -13.53  -17.72   -8.50   -8.15   -8.97   -0.252  -0.374  -0.184 -26.0   -26.0   -26.0    -2.9    -4.3    -2.3];
C_mM   = [  0.00    0.00    0.00    0.020   0.016  -0.092   0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.04   -0.01];
C_met  = [ -1.688  -1.541  -0.771  -0.772  -0.727  -0.638  -0.230  -0.341  -0.071  -1.93  -1.93    -1.93   -1.46   -1.05   -0.8];
C_mka  = [  0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00   0.00     0.00    0.00    0.00    0.00];

%% Derivative der Seitenbewegung
% Die Derivative der Seitenbewegung werden in gleicher Weise wie die
% Flugzustände in Vektoren abgelegt.
%
%            A1      A2      A3     B1      B2      B3      C1      C2      C3      D1      D2      D3      F1      F2      F3
C_Qbe  = [ -1.090  -1.034  -1.149 -0.569  -0.631  -0.755  -0.375  -0.379  -0.424  -1.233  -1.215  -1.195  -1.17   -1.3    -1.0];
C_Qp   = [  2.349   0.624  -0.294 -0.227  -0.213  -0.254   0.050   0.063   0.038   0.150   0.153   0.109   0.00    0.00    0.00];
C_Qr   = [  2.23    2.23    2.33   0.415   0.415   0.514   0.360   0.360   0.319   0.578   0.563   0.576   0.00    0.00    0.00];
C_Qxi  = [  0.00    0.00    0.00   0.00    0.00    0.00    0.144   0.144   0.029   0.00    0.00    0.00    0.00    0.00    0.00];
C_Qze  = [  0.253   0.230   0.176  0.244   0.244   0.244   0.140   0.184   0.045   0.412   0.380   0.389   0.208   0.11    0.05];
C_lbe  = [ -1.432  -1.250  -1.598 -0.420  -0.259  -0.231   0.340  -0.023  -0.098  -0.247  -0.275  -0.285  -0.350  -0.36   -0.12];
C_lp   = [ -9.08   -8.42   -9.82  -0.930  -0.843  -1.01   -0.098  -0.082  -0.067  -1.061  -1.083  -1.118  -0.570  -0.72   -0.56]; 
C_lr   = [  9.39    4.12    3.40   2.83    1.03    0.729   0.0391  0.0129  0.0115  0.349   0.361   0.295   0.530   0.8     0.23];
C_lxi  = [ -0.263  -0.233  -0.125 -0.100  -0.105  -0.110  -0.122  -0.142  -0.0346 -0.300  -0.300  -0.299  -0.078  -0.074  -0.030];
C_lze  = [  0.0945  0.140   0.131  0.032   0.032   0.032   0.0202  0.0271  0.0071  0.0854  0.0836  0.099   0.09    0.056   0.016];
C_nbe  = [  1.063   1.108   1.616  0.222   0.177   0.222   0.0960  0.0989  0.0789  0.535   0.338   0.366   1.0     0.84    0.32];
C_np   = [ -6.36   -2.88   -2.26  -0.429  -0.201  -0.188  -0.0150 -0.0154 -0.0132 -0.199  -0.204  -0.140  -0.28   -0.05   -0.14];
C_nr   = [ -7.71   -6.36   -6.78  -0.329  -0.329  -0.401  -0.140  -0.150  -0.143  -0.628  -0.615  -0.619  -1.5    -2.4    -1.2];
C_nxi  = [ -0.051  -0.049  -0.057  0.00    0.00    0.00   -0.0537 -0.0757 -0.0207 -0.0127 -0.0007 -0.0065 -0.008  -0.042  -0.004];
C_nze  = [ -0.954  -0.883  -0.683 -0.206  -0.206  -0.206  -0.0965 -0.1184 -0.0318 -0.405  -0.384  -0.392  -0.32    -0.18  -0.08];

%% Abspeichern in eine Struktur

% Die Zustandsgrößen und Derivative der Längs- und Seitenbewegung werden
% zur besseren Handhabung in die Struktur FZ gespeichert.

Zustand{1}  = 'A1  - Landeanflug A300';
Zustand{2}  = 'A2  - Warteflug A300';
Zustand{3}  = 'A3  - Reiseflug A300';
Zustand{4}  = 'B1  - Landeanflug Boeing 707 (Fahrwerk ausgefahren)';
Zustand{5}  = 'B2  - Warteflug Boeing 707';
Zustand{6}  = 'B3  - Reiseflug Boeing 707';
Zustand{7}  = 'C1  - Landeanflug Concorde';
Zustand{8}  = 'C2  - Unterschall-Reiseflug Concorde';
Zustand{9}  = 'C3  - Überschall-Reiseflug Concorde';
Zustand{10} = 'D1  - Landeanflug Do 328 (Fahrwerk ausgefahren)';
Zustand{11} = 'D2  - Steigflug  Do 328';
Zustand{12} = 'D3  - Reiseflug  Do 328';
Zustand{13} = 'F1  - Landeanflug Lockheed F104G (Fahrwerk ausgefahren)';
Zustand{14} = 'F2  - Schnellflug in Bodennähe Lockheed F104G';
Zustand{15} = 'F3  - Reiseflug Lockheed F104G';
Kuerzel{1}  = 'A1';
Kuerzel{2}  = 'A2';
Kuerzel{3}  = 'A3';
Kuerzel{4}  = 'B1';
Kuerzel{5}  = 'B2';
Kuerzel{6}  = 'B3';
Kuerzel{7}  = 'C1';
Kuerzel{8}  = 'C2';
Kuerzel{9}  = 'C3';
Kuerzel{10} = 'D1';
Kuerzel{11} = 'D2';
Kuerzel{12} = 'D3';
Kuerzel{13} = 'F1';
Kuerzel{14} = 'F2';
Kuerzel{15} = 'F3';

% Schleife über alle Zustände
for i=1:15
    FZ(i).Bezeichnung   = Zustand{i};
    FZ(i).Kuerzel       = Kuerzel{i};
    FZ(i).V_r           = V_r(i);
    FZ(i).Ma            = Ma(i);
    FZ(i).H             = H(i);
    FZ(i).rho           = rho(i);
    FZ(i).a             = a(i);
    FZ(i).al_r          = al_r(i);
    FZ(i).ga_r          = ga_r(i);
    FZ(i).F             = F(i);
    FZ(i).dF_dM         = dF_dM(i);
    FZ(i).C_Ar          = C_Ar(i);
    FZ(i).C_Aal         = C_Aal(i);
    FZ(i).C_Aalp        = C_Aalp(i);
    FZ(i).C_Aq          = C_Aq(i);
    FZ(i).C_AM          = C_AM(i);
    FZ(i).C_Aet         = C_Aet(i);
    FZ(i).C_Aka         = C_Aka(i);
    FZ(i).C_Wr          = C_Wr(i); 
    FZ(i).C_Wal         = C_Wal(i);
    FZ(i).C_Walp        = C_Walp(i);
    FZ(i).C_Wq          = C_Wq(i);
    FZ(i).C_WM          = C_WM(i);
    FZ(i).C_Wet         = C_Wet(i);
    FZ(i).C_Wka         = C_Wka(i);
    FZ(i).C_mr          = C_mr(i);
    FZ(i).C_mal         = C_mal(i);
    FZ(i).C_malp        = C_malp(i);
    FZ(i).C_mq          = C_mq(i);
    FZ(i).C_mM          = C_mM(i);
    FZ(i).C_met         = C_met(i);
    FZ(i).C_mka         = C_mka(i);
    FZ(i).C_Qbe         = C_Qbe(i);
    FZ(i).C_Qbep        = 0;           %C_Qbep wird vernachlässigt
    FZ(i).C_Qp          = C_Qp(i);
    FZ(i).C_Qr          = C_Qr(i);
    FZ(i).C_Qxi         = C_Qxi(i);
    FZ(i).C_Qze         = C_Qze(i);
    FZ(i).C_lbe         = C_lbe(i);
    FZ(i).C_lbep        = 0;           %C_lbep wird vernachlässigt
    FZ(i).C_lp          = C_lp (i);
    FZ(i).C_lr          = C_lr(i);
    FZ(i).C_lxi         = C_lxi(i);
    FZ(i).C_lze         = C_lze(i);
    FZ(i).C_nbe         = C_nbe(i);
    FZ(i).C_nbep        = 0;           %C_nbep wird vernachlässigt
    FZ(i).C_np          = C_np(i);
    FZ(i).C_nr          = C_nr(i);
    FZ(i).C_nxi         = C_nxi(i);
    FZ(i).C_nze         = C_nze(i);
    
% Umrechnung: Airbus-Derivative der Seitenbewegung sind auf lmy und nicht
% auf s bezogen. Sie werden hier umgerechnet, damit die Ersatzderivative
% mit den unveränderten Formeln berechnet werden können.
if i<=3
    corr=AC(1).lmy/(AC(1).b/2);
    FZ(i).C_Qbep        = FZ(i).C_Qbep * corr;
    FZ(i).C_Qp          = FZ(i).C_Qp   * corr;
    FZ(i).C_Qr          = FZ(i).C_Qr   * corr;
    FZ(i).C_lbe         = FZ(i).C_lbe  * corr;
    FZ(i).C_lbep        = FZ(i).C_lbep * corr^2;
    FZ(i).C_lp          = FZ(i).C_lp   * corr^2;
    FZ(i).C_lr          = FZ(i).C_lr   * corr^2;
    FZ(i).C_lxi         = FZ(i).C_lxi  * corr;
    FZ(i).C_lze         = FZ(i).C_lze  * corr;
    FZ(i).C_nbe         = FZ(i).C_nbe  * corr;
    FZ(i).C_nbep        = FZ(i).C_nbep * corr^2;
    FZ(i).C_np          = FZ(i).C_np   * corr^2;
    FZ(i).C_nr          = FZ(i).C_nr   * corr^2;
    FZ(i).C_nxi         = FZ(i).C_nxi  * corr;
    FZ(i).C_nze         = FZ(i).C_nze  * corr;
end
end
%% Löschen von überflüssigen Variablen
clear C_AM
clear C_Aal
clear C_Aalp
clear C_Aet
clear C_Aka
clear C_Aq
clear C_Ar
clear C_Qbe
clear C_Qp
clear C_Qr
clear C_Qxi
clear C_Qze
clear C_WM
clear C_Wal
clear C_Walp
clear C_Wet
clear C_Wka
clear C_Wq
clear C_Wr
clear C_lbe
clear C_lp
clear C_lr
clear C_lxi
clear C_lze
clear C_mM
clear C_mal
clear C_malp
clear C_met
clear C_mka
clear C_mq
clear C_mr
clear C_nbe
clear C_np
clear C_nr
clear C_nxi
clear C_nze
clear F
clear H
clear Ma
clear V_r
clear Zustand
clear a
clear al_r
clear dF_dM
clear ga_r
clear i
clear rho