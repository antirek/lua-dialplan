Из примера- ну вот например:

Вызов динамического ivr который хранится в реждисе. формируется по определенному алгоритму фронтендом а астериск уже достает значенияю Распарсивает их и считывает необходимые параметрыю Сам пример мало понятен будет без знания алгоритма, но примерно такие задачи я решаю на луа в диалплане (на goto можно не обращать вниманияю Просто это вреезка диалплана на lua в  обычный диалпланю Со временем уберу, так как это в общем то костыль)

function ivr_builder(context,extension)

app.NoOp(extension)
flag=0
fields={}
fields=client:hgetall(extension)

for key,value in pairs(fields) do
    app.NoOp(value)
end

splitted_value={}
splitted_value=split(fields["read"],":")
app.Answer()
app.Read("entered_num",splitted_value[1],splitted_value[2],splitted_value[3],splitted_value[4],splitted_value[5])
for key,value in pairs(fields) do
    if channel.entered_num:get()==key then
        flag=1
    end
end
splitted_value={}

if (flag==1) then
    splitted_value=split(fields[channel.entered_num:get()],":")
    app.Goto(splitted_value[1],splitted_value[2],splitted_value[3])
else
    splitted_value=split(fields["selfent"],":")
    app.Goto("incoming",channel.entered_num:get(),splitted_value[3])
end
