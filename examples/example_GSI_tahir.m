%%
GSI_model= @coeff_DRIA;

h = 300e3;
lat = 0;
lon = 0;
dayOfYear = 1;
UTseconds = 0;
f107Average = 140;
f107Daily = 140;
magneticIndex = ones([1,7])*15;

param_eq = struct;
param_eq = environment(param_eq, h, lat, lon, dayOfYear, UTseconds, f107Average, f107Daily, magneticIndex, 1);

param_eq.Tw = 300;
delta = deg2rad(0:1:90); % Angle from Normal

param_eq.alpha = 1;
param_eq.gamma = cos(delta);
param_eq.ell = sin(delta);
param_eq.alphaN = 0.5;
param_eq.sigmaT = 0.5;
param_eq.sigmaN = 0.5; %hesaplama için gerekli accodomation coeffcienct 

[cp, ctau, cd, cl] = GSI_model(param_eq, delta);


figure
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 10, 10]); % bu kısımı değiştirdim hata vardı
hold on
p_1 = plot(delta*(180/pi),cd);
set(p_1, 'Color', 'k', 'LineStyle','-', 'LineWidth',1.25)
grid on
ylabel('Drag Coefficient, C_D')

yyaxis right
set(gca, 'YColor',[0.5 0.5 0.5])
hold on
p_3 = plot(delta*(180/pi),cl);
set(p_3, 'Color', [0.5 0.5 0.5], 'LineStyle','-','LineWidth',1.25)
ylabel('Lift Coefficient, C_L')

xlabel('Incidence Angle [deg]')
legend('C_D DRIA (\alpha = 1)', 'C_L DRIA (\alpha = 1)')

set(gcf,'color','w');