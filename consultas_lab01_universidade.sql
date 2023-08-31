/* CONSULTAS:
1. Obter o os nomes dos professores que são do departamento denominado
'Informática', sejam doutores, e que, em 932 (2ºsemestre de 1993),
ministraram alguma turma de disciplina do departamento 'Informática' que
tenha mais que três créditos. depto.nomeDepto

2. Obter o número de disciplinas do departamento de ‘Informática’.

3. Obter o número de salas que foram usadas no ano-semestre 941 (1º
semestre de 1994) por turmas do departamento de 'Informática'.

4. Obter os nomes das disciplinas do departamento denominado
'Informática' que têm o maior número de créditos dentre as disciplinas deste
departamento.

5. Para cada departamento, obter seu nome e o número de disciplinas do
departamento. Obter o resultado em ordem descendente de número de
créditos.

6. Nomes dos departamentos que possuem disciplinas que não
apresentam pré requisito.

7. Obter os códigos dos professores que são do departamento de
'Informática' e que ministraram ao menos uma turma em 1994/1.

8. Obtenha os nomes dos departamentos em que há pelo menos uma
disciplina com mais de três créditos.

9. Obter os identificadores das salas (código do prédio e número da sala) que,
em 1994/1: nas segundas-feiras (dia da semana = 2), tiveram ao menos
uma turma do departamento 'Informática'.

10. Mostre a ocupação média das salas em cada prédio no primeiro semestre
de 1994.

11. Para cada prédio, liste a sala que tem a maior capacidade.

12. Qual é a sala mais utilizada? Liste o número da sala e quantas vezes ela
foi usada.

13. Liste o número da sala e quantas vezes ela foi usada (ordem
decrescente).

14. Crie duas visões para as seguintes consultas:
● Obter o código da sala e o código do prédio, desde que a sala
tenha capacidade superior a 35 lugares.
● Sabendo que cada crédito de disciplina corresponde a 15 hora/aula,
retorne o nome da disciplina e o seu número de horas-aula.
*/
use universidade;

#1
select nomeProf from professor, depto, turma, disciplina, titulacao 
	where nomeDepto = "Informática" and nomeTit = "Doutor" and anoSem = 932 and nomeDepto = "Informática" and turma.codDepto = depto.codDepto and disciplina.codDepto = depto.codDepto 
	and creditosDisc > 3 and professor.codDepto = turma.codDepto and professor.codTit = titulacao.codTit and turma.codDepto = depto.codDepto 
	and disciplina.codDepto = depto.codDepto group by nomeProf;
#2
select count(*) from disciplina, depto where nomeDepto = "Informática" and depto.codDepto = disciplina.codDepto;

#3
select count(*) from turma, depto where anoSem = 941 and nomeDepto = "Informática" and turma.codDepto = depto.codDepto and turma.codDepto = depto.codDepto;

#4
select nomeDisc, creditosDisc from disciplina, depto 
	where depto.codDepto = depto.codDepto and disciplina.codDepto = depto.codDepto and nomeDepto = "Informática" order by creditosDisc desc limit 2;

#5
select distinct depto.nomeDepto as departamento, count(disciplina.codDepto) as disciplinas from depto, disciplina 
	where disciplina.codDepto = depto.codDepto group by depto.nomeDepto, disciplina.codDepto order by creditosDisc desc;

#6
select distinct nomeDepto from depto, prereq where prereq.codDepto != depto.codDepto;

#7
select distinct professor.codProf as codigo, professor.nomeProf as professor from professor
	join depto d on d.codDepto = professor.codDepto
    join profturma pt on pt.codProf = professor.codProf
    where pt.anoSem = 941;

#8
select distinct nomeDepto from depto, disciplina where disciplina.creditosDisc > 3 and disciplina.codDepto = depto.codDepto;

#9
select sala.codPred,sala.numSala from sala
	join depto d on d.nomeDepto = "Informática"
	join horario h on h.numSala = sala.numSala and h.CODPRED = sala.codPred and h.codDepto = d.codDepto
    and h.diaSem = 2 and h.anoSem = 941;

#10
select P.nomePred AS Predio, AVG(T.capacidade) AS Media_Turma, AVG(S.capacidade) AS Media_Sala from Turma T 
	join horario H on T.anoSem = H.anoSem and T.codDepto = H.codDepto 
		and T.numDisc = H.numDisc and T.siglaTur = H.siglaTur
	join sala S on H.codPred = S.codPred and H.numSala = S.numSala 
	join predio P on S.codPred = P.codPred
	where T.anoSem = 941 group by P.nomePred;

#11
select nomePred, numSala, sala.capacidade from sala, predio
	where sala.capacidade = (select max(sala.capacidade) from sala s2 where s2.codPred = sala.codPred)
    group by nomePred;

#12
select H.numsala as Sala, COUNT(*) as Quantidade_Uso, H.codPred from Horario H
	group by H.numsala order by Quantidade_Uso DESC limit 1;
    
#13
select H.numsala as Numero_Sala, COUNT(*) as Quantidade_Uso from Horario H 
	group by H.numsala order by Quantidade_Uso desc;

#14
create view Salas_Maior35 as 
	select numSala as Codigo_Sala, codPred as Codigo_Predio from Sala where sala.capacidade > 35;

create view HorasAula_Disciplina as
	select nomedisc as Nome_Disciplina, creditosdisc * 15 as Horas_Aula from Disciplina;
    
SELECT * FROM Salas_Maior35;
SELECT * FROM HorasAula_Disciplina;