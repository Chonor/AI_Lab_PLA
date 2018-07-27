load test.txt
load train.txt
load val.txt

[test_row,test_col]=size(test);
[train_row,train_col]=size(train);
[val_row,val_col]=size(val);

tmp_test=[ones(test_row,1) ,test(:,1:test_col-1)];
sign_test=test(:,test_col);

tmp_train=[ones(train_row,1) ,train(:,1:train_col-1)];
sign_train=train(:,train_col);

tmp_val=[ones(val_row,1) ,val(:,1:val_col-1)];
sign_val=val(:,val_col);

%w=rand(1,train_col);
%ans_w=w;
%相当于种子
w=[0.363164094	0.267443111	0.337302762	0.086960649	0.451559652	0.454664028	0.02903551	0.637101873	0.059458787	0.169196114	0.684679742	0.554567313	0.006035834	0.288085153	0.376611565	0.146493033	0.074533615	0.460742876	0.370394379	0.824557518	0.537535656	0.817516083	0.460380827	0.014033814	0.004983205	0.166226784	0.365938839	0.718210476	0.159423637	0.278771471	0.644938448	0.287204149	0.321930893	0.155416795	0.387663141	0.895733134	0.887766868	0.393613328	0.675457742	0.252214195	0.949987708	0.624682173	0.206947941	0.109655161	0.56584961	0.274333396	0.07116526	0.1584493	0.049520296	0.680883748	0.781755812	0.807365196	0.265053593	0.895899397	0.607986088	0.014400839	0.344028749	0.533664735	0.627762577	0.446737301	0.811105644	0.144827989	0.974829375	0.833760066	0.340101161	0.616239066];
cnt = 0;
max_a = 0;
max_f = 0;
max_w = 0;
n=0.05;%学习
for it = 1 : 20
    for i = 1 : train_row
        if(sign(tmp_train(i,:) * w') ~= sign_train(i,:))   % 跑出来的符号 - 正确符号！=0  说明不匹配  调整直线
            w =w + n * (sign_train(i , : ) - sign(tmp_train(i , : ) * w') )* tmp_train(i , : ); %调整 w
            S=sign(tmp_train * w') + 10 * sign_train;%指标计算
            TP = sum(S( : ) == 11);
            FN = sum(S( : ) == 9);
            TN = sum(S( : ) == -11);
            FP = sum(S( : ) == -9);
            Accuracy = (TP + TN) / (TP + FP + TN + FN);
            Recall = TP / (TP + FN);
            Precision = TP / (TP + FP);
            F1 = (2 *  Precision * Recall) / (Precision + Recall);
            if(Accuracy>max_a && F1>0.5) %贪心
                max_w = w;
                max_a=Accuracy;
                 S=sign(tmp_val * max_w') + 10 * sign_val;
                TP = sum(S( : ) == 11);
                FN = sum(S( : ) == 9);
                TN = sum(S( : ) == -11);
                FP = sum(S( : ) == -9);
                Accuracy = (TP + TN) / (TP + FP + TN + FN);
                Recall = TP / (TP + FN);
                Precision = TP / (TP + FP);
                F1 = (2 *  Precision * Recall) / (Precision + Recall);
                fprintf('\n迭代次数:%d\t正确数量:%d\nAccuracy:%.6f\tRecall:%.6f\nPrecision:%.6f\tF1:%.6f\n',it,(TP + TN),Accuracy,Recall,Precision,F1);
            end
        end
    end
end
ans_test=sign(tmp_test * max_w');
xlswrite('final_ans.xlsx',ans_test);