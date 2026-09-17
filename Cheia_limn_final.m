 %% IMPORTANT! A se rula in Matlab!! 
 clear all
 clc
 format bank
%% IMPORTANT! In GNU Octave nu exista functia 'table'

% Date de intrare
promptb = 'Introduceti o valoare numerica a bazei in metri: b = ';
promptm = 'Introduceti o valoare numerica a pantei taluzelor: m = ';
promptI = 'Introduceti o valoare numerica a pantei canalului (la mie): I = ';
prompt1 = 'Introduceti o valoare numerica pentru rugozitatea 1: n1 = ';
prompt2 = 'Introduceti o valoare numerica pentru rugozitatea 2: n2 = ';
promptq = 'Introduceti o valoare numerica pentru debitul instalat [mc/s]: Qi = ';
% Canal
  b = input(promptb); % Baza mica [m]
  m = input(promptm); % Panta taluzelor
  I = input(promptI); % Panta canalului [la mie]
  n1 = input(prompt1); % Coeficientul de rugozitate
  n2 = input(prompt2); % Coeficientul modificat de rugozitate

% Debit instalat
  Qi = input(promptq); % [mc/s]

  I = I/1000;
% Rezolvare%
   i = 1; A = []; P = []; R = []; C1 = []; v1 = []; Q1 = []; h11 = [];
    for h1 = 0:0.5:50
        A(i)   = (b + m * h1) * h1;
        P(i)   = b + 2 * h1 * sqrt(1 + m^2);
        R(i)   = A(i) / P(i);
        C1(i)  = (1 / n1) * R(i)^(1/6);
        v1(i)  = C1(i) * sqrt(R(i) * I);
        Q1(i)  = v1(i) * A(i);
        h11(i) = h1;
        if Q1(i) > Qi
            break
        end
        i = i + 1;
    end

   
    i = 1; A2 = []; P2 = []; R2 = []; C2 = []; v2 = []; Q2 = []; h22 = [];
    for h2 = 0:0.5:50
        A2(i)  = (b + m * h2) * h2;
        P2(i)  = b + 2 * h2 * sqrt(1 + m^2);
        R2(i)  = A2(i) / P2(i);
        C2(i)  = (1 / n2) * R2(i)^(1/6);
        v2(i)  = C2(i) * sqrt(R2(i) * I);
        Q2(i)  = v2(i) * A2(i);
        h22(i) = h2;
        if Q2(i) > Qi
            break
        end
        i = i + 1;
    end
    deg1 = min(2, length(Q1) - 1);
    deg2 = min(3, length(Q2) - 1);
    Pol1 = polyfit(Q1, h11, deg1);
    Pol2 = polyfit(Q2, h22, deg2);
    h1 = interp1(Q1, h11, Qi, 'spline');
    h2 = interp1(Q2, h22, Qi, 'spline');


% Grafice (CHEIA LIMNIMETRICA)
  plot(Q1, h11,'-o', Q2, h22,'-*')
  grid on
  xlabel('Debit Q [m^3/s]')
  ylabel('Adancime h [m]')
  title('Cheia limnimetrica')

  hold on
% Inaltimi reale
  Pol1 = polyfit(Q1, h11, 2);
  Pol2 = polyfit(Q2, h22, 3);

  %h1 = polyval(Pol1, Qi);
  %h2 = polyval(Pol2, Qi);

  plot(Qi,h1,'ok', Qi,h2+0.1,'*k')
  legend('Rugozitate n_1','Rugozitate n_2','Punctul de coordonate [Q_i, h_1]','Punctul de coordonate [Q_i, h_2]','location','southeast')%
  
  hold off;

  % Tabelul
  dif = length(A2)-length(A);
  lA=length(A);
  A = [A, zeros(1, length(A2)-length(A))];
  P = [P, zeros(1, dif)];
  R = [R, zeros(1, dif)];
  C1 = [C1, zeros(1, dif)];
  v1 = [v1, zeros(1, dif)];
  Q1 = [Q1, zeros(1, dif)];
  h11 = [h11, zeros(1, dif)];
  A = num2cell(A);
  P = num2cell(P);
  R = num2cell(R);
  C1 = num2cell(C1);
  v1 = num2cell(v1);
  Q1 = num2cell(Q1);
  h11= num2cell(h11);
  for i =lA+1:length(A2)
    
    A{i} = 'null';
    P{i} = 'null';
    R{i} = 'null';
    C1{i} = 'null';
    v1{i} = 'null';
    Q1{i} = 'null';
    h11{i} = 'null';
  end

 T = table(h22', A',P', R', C1',v1',Q1', C2',v2', Q2',...
     'VariableNames', {'h [m]', 'A [m^2]', 'P [m]',...
     'R [m]', 'C_1 [m^(0,5)/s]', 'v_1 [m/s]',...
     'Q_1 [m^3/s]', 'C_2 [m^(0,5)/s]', 'v_2 [m/s]',...
     'Q_2 [m^3/s]'})


 h1
 h2