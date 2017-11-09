%Aixo s'ha de picar a Matlab
%Punts vermells -> demanda
%Quadrat blau -> capacitat -> AAR (AAR en una hora passar a "paquets" de 15 min)
%Plot de punts vermells i cuadrat blau.
%La capacitat teorica no es la mateix

x = [0, 8, 8, 0, 0];
y = [0, 0, 8, 8, 0];

vx = [2, 2, 4, 5, 5, 8, 8, 10];
vy = [9, 0, 2, 6, 4, 8, 3,  3];

plot(x, y, 'b-');
hold on;
plot(vx, vy, 'ro');
title('Airport Arrival/Departure capacity curve');xlabel('Arrival/15 min');ylabel('Departures/15 min');
xlim([0, 11]);ylim([0, 11]);
