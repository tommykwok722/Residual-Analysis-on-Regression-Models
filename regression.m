% Read txt file
fishData = readtable('fishdata.txt');

% Extract a total of 201 observations (665th-865th) from the whole data
fishData = fishData(665:865,:);

Length = table2array(fishData(:,1));
Height = table2array(fishData(:,2));
Width = table2array(fishData(:,3));
Species = table2array(fishData(:,4));
Weight = table2array(fishData(:,5));

% Figure 1: Matrix scatter plot
X = [Length Height Width Species Weight];
xnames = {'Length','Height','Width','Species','Weight'};
color = lines(3);
gplotmatrix(X,[],Species,color,[],[],[],'variable',xnames);

fishData.logWeight = log(Weight);        % Take log on 'Weight'
fishData.Species = categorical(Species); % Create dummy variables for 'Species'

% Model #1
fit1 = fitlm(fishData, 'Weight ~ Length + Height + Width');
% Model #2
fit2 = fitlm(fishData, 'logWeight ~ Length + Height + Width + Species');
% Model #3
fit3 = fitlm(fishData, 'logWeight ~ Length + Height + Width + Species + Length*Species');

% Figure 2: Plot of residuals vs. fitted values
figure(2); tiledlayout(1,3)
nexttile; plotResiduals(fit1, 'fitted')
nexttile; plotResiduals(fit2, 'fitted')
nexttile; plotResiduals(fit3, 'fitted')

% Figure 3: Plot of studentized residuals vs. fitted values
figure(3); tiledlayout(1,3)
nexttile; plotResiduals(fit1, 'fitted', 'ResidualType', 'studentized')
nexttile; plotResiduals(fit2, 'fitted', 'ResidualType', 'studentized')
nexttile; plotResiduals(fit3, 'fitted', 'ResidualType', 'studentized')

% Number of outliers based on studentized residuals
res = table2array(fit1.Residuals(:,3));
numOut1 = length(find(abs(res) > 2));

res = table2array(fit2.Residuals(:,3));
numOut2 = length(find(abs(res) > 2));

res = table2array(fit3.Residuals(:,3));
numOut3 = length(find(abs(res) > 2));

% Figure 4: Plot on Leverage
figure(4); tiledlayout(1,3)
nexttile; plotDiagnostics(fit1, 'leverage'); legend('show')
nexttile; plotDiagnostics(fit2, 'leverage'); legend('show')
nexttile; plotDiagnostics(fit3, 'leverage'); legend('show')

% Number of leverage points of the 3 regression models
t_leverage = 2*fit1.NumCoefficients/fit1.NumObservations;
numLev1 = length(find(fit1.Diagnostics.Leverage > t_leverage));

t_leverage = 2*fit2.NumCoefficients/fit2.NumObservations;
numLev2 = length(find(fit2.Diagnostics.Leverage > t_leverage));

t_leverage = 2*fit3.NumCoefficients/fit3.NumObservations;
numLev3 = length(find(fit3.Diagnostics.Leverage > t_leverage));

% Figure 5: Plot on Cook's distance
figure(5); tiledlayout(1,3)
nexttile; plotDiagnostics(fit1, 'cookd'); legend('show')
nexttile; plotDiagnostics(fit2, 'cookd'); legend('show')
nexttile; plotDiagnostics(fit3, 'cookd'); legend('show')

% Number of influential points based on Cook's distance
t_cookd = 3*mean(fit1.Diagnostics.CooksDistance,'omitnan');
numInf.CD1 = length(find(fit1.Diagnostics.CooksDistance > t_cookd));

t_cookd = 3*mean(fit2.Diagnostics.CooksDistance,'omitnan');
numInf.CD2 = length(find(fit2.Diagnostics.CooksDistance > t_cookd));

t_cookd = 3*mean(fit3.Diagnostics.CooksDistance,'omitnan');
numInf.CD3 = length(find(fit3.Diagnostics.CooksDistance > t_cookd));

% Figure 6: Plot on Difference in Fitted Values (DFFITS)
figure(6); tiledlayout(1,3)
nexttile; plotDiagnostics(fit1, 'dffits'); legend('show')
nexttile; plotDiagnostics(fit2, 'dffits'); legend('show')
nexttile; plotDiagnostics(fit3, 'dffits'); legend('show')

% Number of influential points based on DFFITS
t_dffits = 2*sqrt(fit1.NumCoefficients/fit1.NumObservations);
numInf.DF1 = length(find(abs(fit1.Diagnostics.dffits) > t_dffits));

t_dffits = 2*sqrt(fit2.NumCoefficients/fit2.NumObservations);
numInf.DF2 = length(find(abs(fit2.Diagnostics.dffits) > t_dffits));

t_dffits = 2*sqrt(fit3.NumCoefficients/fit3.NumObservations);
numInf.DF3 = length(find(abs(fit3.Diagnostics.dffits) > t_dffits));

% Obtain Residuals Sum of Squares (RSS)
res = table2array(fit1.Residuals(:,1));
RSS1 = sum(res.^2);

res = table2array(fit2.Residuals(:,1));
RSS2 = sum(res.^2);

res = table2array(fit3.Residuals(:,1));
RSS3 = sum(res.^2);