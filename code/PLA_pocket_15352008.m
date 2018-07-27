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

w=ones(1,val_col);

max_w = w;
flag=sign(tmp_train * w')-sign_train; %求当前w 和训练集中所有数据相乘 跑出来的符号 - 正确符号
cnt = sum( flag( : ) == 0);
max = cnt;
for it = 1 : 219
    for i = 1 : train_row
        if(flag(i) ~= 0)   % 跑出来的符号 - 正确符号！=0  说明不匹配  调整直线
            w =w + sign_train( i , : ) * tmp_train(i , : ); %调整 w
            flag = sign(tmp_train * w') - sign_train; %调整后的w 从新跑出来的符号 - 正确符号
            cnt = sum( flag( : ) == 0);  %计算 跑出来的符号 == 正确符号 的个数
            if(cnt > max) %贪心
                max = cnt;
                %it 
                max_w = w;
%       实际*10 + 结果  =      S   加速界的噩梦 抛弃for
%TP       1            1             11
%FN      1            -1             9
%TN     -1           -1           -11 
%FP     -1             1             -9
%                
                S=sign(tmp_val * max_w') + 10 * sign_val;
                TP = sum(S( : ) == 11);
                FN = sum(S( : ) == 9);
                TN = sum(S( : ) == -11);
                FP = sum(S( : ) == -9);
                count = sum( ( sign(tmp_val * max_w') - sign_val) == 0);
                Accuracy = (TP + TN) / (TP + FP + TN + FN);
                Recall = TP / (TP + FN);
                Precision = TP / (TP + FP);
                F1 = (2 *  Precision * Recall) / (Precision + Recall);
                fprintf('\n迭代次数:%d\t正确数量:%d\nAccuracy:%.6f\tRecall:%.6f\nPrecision:%.6f\tF1:%.6f\n',it,count,Accuracy,Recall,Precision,F1);
            end
        end
    end
end
ans_test=sign(tmp_test * max_w');
xlswrite('pocket_ans.xlsx',ans_test);