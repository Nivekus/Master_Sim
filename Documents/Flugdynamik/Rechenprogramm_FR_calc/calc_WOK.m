%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Technische Universit�t Berlin - Fakult�t V                              %
% Institut f�r Luft- und Raumfahrttechnik                                 %
% Fachgebiet Flugmechanik, Flugregelung und Aeroelastizit�t               %
% Prof. Dr.-Ing. Robert Luckner                                           %
%                                                                         %
% Projektname:      FR_calc - Berechnungstool f�r das Buch Flugregelung   %
% Datei:            calc_WOK.m                                            %
% Zweck:            Darstellung der Wurzelortskurven                      %
%                                                                         %
% Autoren:          Prof. Dr.-Ing. Robert Luckner                         %
%                   Dipl.-Ing. Andrej Sch�nfeld                           %
%                   Alexander K�the, B.Sc.                                %
%                   cand.-Ing. Fadi Bitar                                 %
%                                                                         %
% Version :         1.0                                                   %
% Datum   :         28.10.2011                                            %
%                                                                         %
%_________________________________________________________________________%
%                                                                         %
% Revisionen                                                              %
% ----------                                                              %
% Nr.  Datum     Autor          �nderung                                  %
% ---  --------  -------------  ---------------------------------------   %
%                                                                         %
%_________________________________________________________________________%
%                                                                         %
% Alle Daten in SI-Einheiten, Winkel werden in Grad ein- und ausgegeben,  %
% m�ssen aber programmintern in das Bogenma� umgerechnet werden           %
%                                                                         %
% externe Variable                                                        %
% ----------------                                                        %
% Eingangsgr��en:  ZR            - Zustandsraum                           %
%                  AlleFlugzeuge - Auswahl                                %
%                                  (1 - ein Flugzeug; 2 - alle Flugzeuge) %
%                  prefix        - Praefix f�r Fall und Bewegungsform     %
% Ausgabgsgr��en:  keine                                                  %
%                                                                         %
%_________________________________________________________________________%
%                                                                         %
% interne Variable                                                        %
% ----------------                                                        %
%               Bezeichnung im Buch                                       %
% Matlab        (TeX-Rohformat)       Bedeutung                           %
% -------       ------------------    ----------------------------------- %
% Error         ---                   Fehlercode                          %
% Auswahl       ---                   String Eingabe durch den Nutzer     %
% auxauswahl    ---                   Integer Wert der Nutzereingabe      %
% i             ---                   Z�hlvariable                        %
% j             ---                   Z�hlvariable                        %
% state         ---                   Anzahl der Zust�nde                 %
% input         ---                   Anzahl der Steuergr��en             %
% start         ---                   Startparameter f�r die Verst�rkung  %
% ende          ---                   Endparameter f�r die Verst�rkung    %
% Anzahl        ---                   Anzahl der Zwischenschritte der     %
%                                     Verst�rkung                         %
% Vorzeichen    ---                   Vorzeichen der Verst�rkung          %
% k             K                     Verst�rkungsfaktor                  %
% P             P                     Pole als Funktion der Verst�rkung   %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Beginn Hauptprogramm

function calc_WOK(ZR,Verzeichnis,AlleFlugzeuge,prefix)

% Ermitteln, ob L�ngs- oder Seitenbewegung
if ZR.StateName{1}=='q'
    Bewegung='L�ngsbewegung';
elseif ZR.StateName{1}=='r'
    Bewegung='Seitenbewegung';
else
    Bewegung='unbekannt';
end

if AlleFlugzeuge~=2
    % Grafische Darstellung der Wurzelortskurven
    disp(' ');
    disp('Sollen die Wurzelortskurven grafisch dargestellt werden?');
    disp('1 - ja');
    disp('2 - nein');
    disp(' ');
    % Abfrage zur Eingabe
    Error = 1;
    while (Error == 1)
        Auswahl = input('Ihre Auswahl: ','s');
        Error = Darstellungsauswahl(Auswahl);
        if (Error ~= 1)
            auxAuswahl = str2double(Auswahl);
        end
    end
else
    auxAuswahl = 1;
end
if auxAuswahl == 2
    return;
else
    % Bestimmung von Zustands- und Steuergr��en
    [state,Input] = size(ZR.b);
    
    for i=1:state
        for j=1:Input
            
            % Auswahl der Parameter f�r die Darstellung
            start=0;
            ende=3;
            Anzahl=16;
            Vorzeichen=-1;
            
%            Korrektur bei Schub
            SCHUBK = strcmp(ZR.InputName{j}, 'f');
            SCHUBV = strcmp(ZR.StateName{i}, 'V');

            if ((SCHUBK==1) && (SCHUBV==1))
                Vorzeichen = Vorzeichen / 10;
            elseif (SCHUBK==1)
                Vorzeichen = Vorzeichen * 10;
            else
                Vorzeichen = -1;
            end
%             
            % Festlegen des Verst�rkungsfaktors K
            k=Vorzeichen*linspace(start,ende,Anzahl);
            
            % Bestimmung der Pole aus der Wurzelortskurve bei Verst�rkung k
            [P,k]=rlocus(ZR(i,j),k);
            
            % Abfangen, ob die WOK erstellt werden kann
            if (length(P) > 0)
                % Graphische Ausgabe der Wurzelortskurven
                h = figure('Name',(['Wurzelortskurven ',ZR.StateName{i},' -> ',ZR.InputName{j}]),'units','normalized','outerposition',[0 0 1 1]);
                [pol,zero] = pzmap(ZR(i,j));
                plot(real(P(1,:)),imag(P(1,:)),'k+',...
                    real(P(2,:)),imag(P(2,:)),'k+',...
                    real(P(3,:)),imag(P(3,:)),'k+',...
                    real(P(4,:)),imag(P(4,:)),'k+',...
                    'LineWidth',2,'MarkerSize',6);
                hold on;
                plot(real(pol(:)),imag(pol(:)),'b+',...
                    real(zero(:)),imag(zero(:)),'bo',...
                    'LineWidth',2,'MarkerSize',10)
                hold on
                
%                 Ausgabe = ['   k =',num2str(k(1))];
%                 text(real(P(1,1)),imag(P(1,1)),Ausgabe,'FontSize',12);
%                 hold on;
%                 Ausgabe = ['   k =',num2str(k(1))];
%                 text(real(P(2,1)),imag(P(2,1)),Ausgabe,'FontSize',12);
%                 hold on;
%                 Ausgabe = ['   k =',num2str(k(1))];
%                 text(real(P(3,1)),imag(P(3,1)),Ausgabe,'FontSize',12);
%                 hold on;
%                 Ausgabe = ['   k =',num2str(k(1))];
%                 text(real(P(4,1)),imag(P(4,1)),Ausgabe,'FontSize',12);
%                 hold on;
                
                Ausgabe = ['   k =',num2str(k(6))];
                text(real(P(1,6)),imag(P(1,6)),Ausgabe,'FontSize',12);
                hold on;
                Ausgabe = ['   k =',num2str(k(6))];
                text(real(P(2,6)),imag(P(2,6)),Ausgabe,'FontSize',12);
                hold on;
                Ausgabe = ['   k =',num2str(k(6))];
                text(real(P(3,6)),imag(P(3,6)),Ausgabe,'FontSize',12);
                hold on;
                Ausgabe = ['   k =',num2str(k(6))];
                text(real(P(4,6)),imag(P(4,6)),Ausgabe,'FontSize',12);
                hold on;
%                 
%                 Ausgabe = ['   k =',num2str(k(16))];
%                 text(real(P(1,16)),imag(P(1,16)),Ausgabe,'FontSize',12);
%                 hold on;
%                 Ausgabe = ['   k =',num2str(k(16))];
%                 text(real(P(2,16)),imag(P(2,16)),Ausgabe,'FontSize',12);
%                 hold on;
%                 Ausgabe = ['   k =',num2str(k(16))];
%                 text(real(P(3,16)),imag(P(3,16)),Ausgabe,'FontSize',12);
%                 hold on;
%                 Ausgabe = ['   k =',num2str(k(16))];
%                 text(real(P(4,16)),imag(P(4,16)),Ausgabe,'FontSize',12);
%                 hold on;
%                 
                
                title([prefix,' - ',Bewegung,': WOK ',ZR.StateName{i},' \rightarrow ',ZR.InputName{j}],'Fontsize',16)
                xlabel('\sigma [rad/s]','Fontsize',16)
                ylabel('\omega [rad/s]','Fontsize',16)
                axis equal
                sgrid;
                
                %Ausgabe des Wurzelortskurve in pdf-Datei 
                Zustandsname = ZR.StateName{i};
                Eingangsname = ZR.InputName{j};
                if strcmp(Zustandsname(1),'\')
                    Zustandsname = Zustandsname(2:length(Zustandsname));
                end
                if strcmp(Eingangsname(1),'\')
                    Eingangsname = Eingangsname(2:length(Eingangsname));
                end
                orient landscape
                print(h,'-dpdf','-r300',[Verzeichnis,'\Grafiken\',prefix,' - Wurzelortskurve R�ckf�hrung von ',Zustandsname,' auf ',Eingangsname]);
                
            end
        end
    end
    
    if AlleFlugzeuge~=2
        disp('Bitte mit beliebiger Taste fortsetzen...');
        pause;
    end
    close all;
end

end

function Error = Darstellungsauswahl(Auswahl)

if (strcmp(Auswahl,'1') || strcmp(Auswahl,'2'))
    Error = 0;
else
    disp(' ');
    disp('Ihre Eingabe konnte nicht zugeordnet werden. Bitte wiederholen Sie Ihre Eingabe!');
    disp('1 - Darstellung');
    disp('2 - Ohne Darstellung fortfahren');
    disp(' ');
    Error = 1;
end
end
