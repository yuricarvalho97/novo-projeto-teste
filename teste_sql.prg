function teste_sql()
   #include 'sqllib.ch'
   
   //colocar no texto (documentação do harbour x SQL) , o que é a lib, quais são TODOS (.ch,.lib,.dll) os arquivos necessários para gerar o código, 
   //comentar no .BC inclusive
   //comentar os objs (Servinn) mecessários pra função sql_execute e sua inclusão no BC
   
   //nota: Interessante reparar que a funcao sql_execute(), utilizada nesse exemplo, encontra se no : arqs.obj , porém as outras dependencias desse
   //arquivo são tantas que é necessário compilar junto diversos outros objs (com a maioria de código inútil nesse exemplo), isso mostra como estão 
   //mal distribuídas as funções e seus correlatos prgs,
   //mais um trabalho importante ao planejar refatorar o código...
   //a dependencia do obj: erros causa uma grave inconformidade em tempo de execução pois depende de certas 
   //variáveis de ambiente que só funcionam em nosso "mvc proprietário" dificultando o laboratório desse exemplo,
   //esse problema da dependência causada por esse código não planejado deverá ser resolvida com o intuito de 
   //mantermos o exercício do harbour x sql limpo e objetivo...
   par_ip="localhost"
   par_usu="root"
   par_sen="new_sql"
   par_banco="sys_clientes"
   par_porta="4407"
   
   cCon := 'Driver=MySQL;ip='+par_IP+';usuario='+par_Usu+';senha='+par_Sen+';banco='+par_Banco+';porta='+par_Porta
   
   Sql Connect cCon Into mPorta
   If mPorta=0
      alert("Erro na conexão !!!!")
   EndIf
   
   clear //limpa a tela
   
   @ 10,10 say "TESTE DE CONEXAO USANDO A BIBLIOTECA: libmysql.lib"
   @ 13,10 say "CONECTADO NO BANCO:"+par_banco+" COM SUCESSO" 
   
   //@ 16,0 say "Clientes:"
   //@ 16,20 say "CPF:"

   infoClientes := SQLArray("SELECT nome_cliente, cpf_cliente FROM Clientes")
   ? toString (infoClientes)
  

   inkey(0) //aguarda pressionar qualquer tecla
   
   return .t.      