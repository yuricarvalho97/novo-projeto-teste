/*
 * SQL LIB
 * A SQL RDD & API framework
 * for Harbour
 *
 * Constants for Events into API
 * By Vailton Renato
 *
 * 03-09-2004 - 22:30
 */

#ifndef _SQL_LIB_CH
#define _SQL_LIB_CH

#ifndef SQL_LIB_DEFs
#define SQL_LIB_DEFs

*     Translate Path
#translate tpFileName         => 00
#translate tpFullPath         => -1
#translate tpFullName         => -2 // 04/02/2006 -> v1.0d add
#translate tpFullNamePath     => -3 // 04/02/2006 -> v1.0d add

*     Translate Case
#translate tcNone             => 00
#translate tcUpperCase        => 01
#translate tcLowerCase        => 02
#endif

#include "sqlerror.ch"

* Conecta no BD com parametros separados
#command SQL CONNECT ON <cHost>                                          ;
                    [PORT <nPort>]                                       ;
                    [DATABASE <cDb>]                                     ;
                    [USER <cUser>]                                       ;
                    [PASSWORD <cPwd>]                                    ;
                    [OPTIONS <nFlags>]                                   ;
                    <y:LIB,DRIVER,RDD,VIA> <SqlLibName>                  ;
                    [INTO <x>]                                           ;
                                                                   =>    ;
     [<x> := ] SqlLib_Conn( <cHost>, <nPort>, <cDb>, <cUser>,            ;
                  <cPwd>, <nFlags>, <SqlLibName> )

* Conecta no DB apartir de uma string * * * S.R. LIKE STYLE * * *
#command SQL CONNECT <cConn> [INTO <x>]  => [<x> := ]SqlLib_ConnParse( <cConn> )

* Desconectar-se do DB
#command SQL DISCONNECT [FROM] <nHandle> => SQLLIB_Disconn( <nHandle> )
#command SQL DISCONNECT [<x:ALL>]        => SQLLIB_Disconn( <.x.> )


#command USE <(SQL)>                                                    ;
             [VIA <rdd>]                                                ;
             [ALIAS <a>]                                                ;
             [INDEX <(index1)> [, <(indexn)>]]                          ;
             [<x:CONNECTION,INTO> <conn>]                               ;
             [<new: NEW>]                                               ;
             [<ex: EXCLUSIVE>]                                          ;
             [<sh: SHARED>]                                             ;
             [<ro: READONLY>]                                           ;
                                                                        ;
      => [SQLSetConn( <conn>, .F. );]                                   ;
         dbUseArea(                                                     ;
                    <.new.>, <rdd>, <(SQL)> , <(a)>,                    ;
                    if(<.sh.> .or. <.ex.>, !<.ex.>, NIL), <.ro.>        ;
                  )                                                     ;
                                                                        ;
      [; dbSetIndex( <(index1)> )]                                      ;
      [; dbSetIndex( <(indexn)> )]

* Voce pode abrir uma QUERY como ser fosse uma tabela no DB,
* com este comando (note que ele nao oferece suporte para a opcao INDEX
* utilizada normalmente pelo comando USE):
#command USE SQL <(SQL)>                                                ;
             [VIA <rdd>]                                                ;
             [ALIAS <a>]                                                ;
             [INTO <conn>]                                              ;
             [<new: NEW>]                                               ;
             [<ex: EXCLUSIVE>]                                          ;
             [<sh: SHARED>]                                             ;
             [<ro: READONLY>]                                           ;
                                                                        ;
      => [SQLSetConn( <conn>, .F. );]                                   ;
         [SQLSetQuery( <SQL>, .F. );]                                   ;
         dbUseArea(                                                     ;
                    <.new.>, iif(<.rdd.>,<rdd>,SQLGetRddName(<conn>)), "*", NextQueryAlias(<(a)>),         ;
                    if(<.sh.> .or. <.ex.>, !<.ex.>, NIL), <.ro.>        ;
                  )

* Mediator  * * * LIKE STYLE * * *
#command USE <(db)>                                                     ;
        AS <SQL>                                                        ;
             [INTO <conn>]                                              ;
             [VIA <rdd>]                                                ;
             [ALIAS <a>]                                                ;
             [<new: NEW>]                                               ;
        [<sh: SHARED>]                    ;
        [<ex: EXCLUSIVE>]                 ;
        [<ro: READONLY>]                  ;
        [<c1log: C1LOGICAL>]              ;
        [<ovr: OVERWRITE>]                ;
             [PRECISION <p>]              ;
        [<scr: SCROLLABLE>]               ;
        [<prmt: PERMANENT>]               ;
                                                                        ;
      => [SQLSetConn( <conn>, .F. );]                                   ;
         [SQLSetQuery( <SQL>, .F. );]                                   ;
         dbUseArea(                                                     ;
                    <.new.>, iif(<.rdd.>,<rdd>,SQLGetRddName(<conn>)), "*", NextQueryAlias(<(a)>),         ;
                    if(<.sh.> .or. <.ex.>, !<.ex.>, NIL), <.ro.>        ;
                  )

* Execucao direta de um SQL no DB ** avancado
*command SQL EXECUTE <cSQL> [INTO <nHandle>]   => SQLLIB_ExecSQL( <nHandle>, <cSQL> )
#command SQL EXECUTE <cSQL> [INTO <nHandle>] [WITH <aParms,...>]  => SQLExecute( <cSQL>, \{ <aParms> \}, <nHandle> )
#command SQL EXECUTE <cSQL> [INTO <nHandle>] [WITH ARRAY <aParms,...>]  => SQLExecute( <cSQL>, <aParms>, <nHandle> )

*
* PostgreSQL novos recursos/detalhes
*
* Suporte à SCHEMAs. O comando abaixo muda o SCHEMA ativo. Você pode obter o
* nome do SCHEMA atual apenas chamando a funcao abaixo sem parâmetros.
*
* Note que temos 2 comandos para manipulação de SCHEMAS, um é para a TABELA
* individualmente aberta com USE. A segunda função é utilizada pela SQL LIB
* para acessar as tabelas do sistema, tais como SQL$INDEXES e outras que possam
* surgir.
*
#command SELECT SCHEMA <cSchemaName>         => SQLSchema( <(cSchemaName)> )
#command SELECT SYSTEM SCHEMA <cSchemaName>  => SQLSystemSchema( <(cSchemaName)> )

* Execucao direta de modo simplificado
#command SQL DELETE <*cSQL*>    => SQLLIB_ExecSQL( , ( 'DELETE '+ <(cSQL)> ))
#command SQL INSERT <*cSQL*>    => SQLLIB_ExecSQL( , ( 'INSERT '+ <(cSQL)> ))
#command SQL UPDATE <*cSQL*>    => SQLLIB_ExecSQL( , ( 'UPDATE '+ <(cSQL)> ))
#command SQL ALTER  <*cSQL*>    => SQLLIB_ExecSQL( , ( 'ALTER ' + <(cSQL)> ))
#command SQL CREATE <*cSQL*>    => SQLLIB_ExecSQL( , ( 'CREATE '+ <(cSQL)> ))
#command SQL DROP   <*cSQL*>    => SQLLIB_ExecSQL( , ( 'DROP '  + <(cSQL)> ))
#command SQL RENAME <*cSQL*>    => SQLLIB_ExecSQL( , ( 'RENAME '+ <(cSQL)> ))
#command SQL UPDATE <*cSQL*>    => SQLLIB_ExecSQL( , ( 'UPDATE '+ <(cSQL)> ))
#command SQL GRANT  <*cSQL*>    => SQLLIB_ExecSQL( , ( 'GRANT ' + <(cSQL)> ))
#command SQL REVOKE <*cSQL*>    => SQLLIB_ExecSQL( , ( 'REVOKE '+ <(cSQL)> ))
#command SQL VACUUM <*cSQL*>    => SQLLIB_ExecSQL( , ( 'VACUUM '+ <(cSQL)> ))
#command SQL SELECT <*cSQL*>    => [SQLSetQuery( ( 'SELECT '+ <(cSQL)> ), .F. );] ;
                                   dbUseArea( .T., , "*", SQLlib_NextQueryAlias(), nil, .t. )

* Os comandos abaixo sao compativeis com o MySQL e permanecerao assim,
* a menos que venham a causar algum tipo de conflito com o pre-processador e
* a sintaxe de outros BDs:
#command SQL SHOW <*cSQL*>      => ;
         dbUseArea( .T., , ( 'SHOW '+ <(cSQL)> ), SQLlib_NextQueryAlias(), nil, .t. )
#command SQL OPTIMIZE <*cSQL*>  => SQLLIB_ExecSQL( , ( 'OPTIMIZE '+ <(cSQL)> ))

* Ativa ou nao as MSGs de alertas da SQL LIB
#command SQL ENABLED  UNSUPPORTED_WARNINGS   => SQLLIB_DisabledWarnings(.T.)
#command SQL DISABLED UNSUPPORTED_WARNINGS   => SQLLIB_DisabledWarnings(.F.)

*
* Especifica o tipo de conversao no PATH dos DBFs para os softs antigos, por exemplo,
* se vc usar um comando USE C:\PROGRAMA\ARQUIVOS\DBF\ESTOQUE.DBF, veja como a SQL LIB
* irá interpretar esta valor, dependendo de SET TRANSLATE:
*
* SET TRANSLATE PATH TO tpFileName     => Resulta em "ESTOQUE", este ‚ o valor ** DEFAULT **
*                       tpFullPath     => Resulta em "PROGRAMA_ARQUIVOS_DBF_ESTOQUE"
*                       tpFullName     => Resulta em "ESTOQUE_DBF"
*                       tpFullNamePath => Resulta em "PROGRAMA_ARQUIVOS_DBF_ESTOQUE_DBF"
*
* Esta conversÆo afeta tb os nomes do indices passados para a SQL LIB, veja o exemplo
* PARSE.PRG para ver como a fun‡Æo SQLPARSE ‚ afetada por este processo e como vc pode
* usar ele em seus sistemas.
*
#command SQL TRANSLATE PATH TO <x> [INTO <nHandle>]      => SQLParseStyle(<x>, <nHandle> )
#command SET TRANSLATE PATH TO <x> [INTO <nHandle>]      => SQLParseStyle(<x>, <nHandle> )
*
* O comando abaixo especifica o tipo de conversÆo no caso de mai£sculas / minusculas
* para os nomes de arquivos. Isto ajuda a converter todo o sistema, caso  o servidor
* seja em LINUX e o nome dos arquivos estiverem em letras diferentes.
*
* SET TRANSLATE CASE TO tcNone        => NÆo faz conversÆo nenhuma (agora ‚ o padrÆo)
* SET TRANSLATE CASE TO tcUpperCase   => Converte tudo para maiusculas
* SET TRANSLATE CASE TO tcLowerCase   => Converte tudo para minisculas
*
#command SET TRANSLATE CASE TO <x> [INTO <nHandle>]      => SQLParseCase( <x>, <nHandle> )
#command SQL TRANSLATE CASE TO <x> [INTO <nHandle>]      => SQLParseCase( <x>, <nHandle> )
*
* O comando abaixo, indica se a SQL LIB deve permitir o uso de índices com chave
* customizável, ex: INDEX ON Substr( nome, 2,5) + DESCEND( data ). O padrão é .F.
*
#command SET CUSTOM INDEXES <x:ON,OFF>         => SQLUseCustomIndexes( <"x"> )
#command SQL CUSTOM INDEXES <x:ON,OFF>         => SQLUseCustomIndexes( <"x"> )
*
* Especifica QTOS registros devem ser trazidos do servidor por vez
* utilize a mesma função sem parametros para recuperar o valor atual... (default:50)
*
* Detalhe importante, use apenas ANTES de abrir o arquivo...
*
#command SQL [SET] PACKETSIZE [TO] <x>         => SQL_PacketSize( <x> )
#command SET PACKETSIZE [TO] <x>               => SQL_PacketSize( <x> )
*
* Caso necessite alterar o PACKETSIZE depois do arquivo aberto, estando ele
* no ALIAS() atual, use este comando aqui para sincronizar:
*
#command SQL [SET] CURRENT PACKETSIZE [TO] <x> => SQLPacketSize( <x>, .T. )
#command SET CURRENT PACKETSIZE [TO] <x>       => SQLPacketSize( <x>, .T. )
*
* Determina se um registro deve ser realmente deletado da tabela ou apenas
* marcado para deleção - o padrão é FALSE
#command SQL FULLDELETE ON                     => SQL_FullDelete( .T. )
#command SQL FULLDELETE OFF                    => SQL_FullDelete( .F. )

* Estabiliza um FILTRO do lado do servidor
#command SQL FILTER TO <cSQLFilter>           => SQLFilter( <cSQLFilter> )
#command SQL FILTER TO                        => SQLFilter( "" )

* Limpa todos os ¡ndices da tabela atual ou espec¡fica
#command CLEAR INDEXES [<x:FROM,FOR> <table>]  => SQL_ClearIndexes(<table>)

* Copia o conteudo de uma nova tabela para outra
#command COPY TABLE <source> TO <dest>         => SQL_CopyTable( <(source)>, <(dest)> )

* Deleta uma tabela do arquivo
#command DELETE TABLE <source>                 => SQL_DropTable( <(source)> )
#command DROP TABLE <source>                   => SQL_DropTable( <(source)> )

* Deleta um ou mais INDICES do banco de dados.
* Utilize "*" como curinga para mais de um arquivo.
#command DELETE INDEX <source>                 => SQL_DropIndex( <(source)> )
#command DROP INDEX <source  >                 => SQL_DropIndex( <(source)> )

* Renomeia uma tabela
#command RENAME TABLE <source> TO <dest>       => SQL_RenameTable( <(source)>, <(dest)> )

* Renomeia um Indice
#command RENAME INDEX <source> TO <dest>       => SQL_RenameIndex( <(source)>, <(dest)> )

#command TRANSACTION START                     => SQLBeginTrans()
#command TRANSACTION BEGIN                     => SQLBeginTrans()
#command TRANSACTION END                       => SQLEndTrans()

#command START TRANSACTION                     => SQLBeginTrans()
#command BEGIN TRANSACTION                     => SQLBeginTrans()
#command END TRANSACTION                       => SQLEndTrans()

#command COMMIT TRANSACTION                    => SQLCommit()
#command SQL COMMIT                            => SQLCommit()

#command ROLLBACK TRANSACTION                  => SQLRollBack()
#command SQL ROLLBACK                          => SQLRollBack()

*
* New drivers ID's (or SystemIDs) constants
*
#define MYSQL_ID      01
#define POSTGRESQL_ID 02
#define ORACLE_ID     03
#define SQLSERVER7_ID 04

#define POSTGRES_ID   POSTGRESQL_ID
#define PGSQL_ID      POSTGRESQL_ID
*
* BACKUP Constants - nMode values.
*
#define SQL_BACKUP_BEGIN     01
/* BKP Started -> .T. Process / .F. Cancel Backup
   params: mode, objname (filename), data(handle of file) */
   
#define SQL_BACKUP_END       02
/* BKP Finished -> (Result value ignored)
   params: mode, objname (filename), data(handle of file) */
   
#define SQL_BACKUP_DDL       03
/* Extract DDL -> .T. Write into Backup File / .F. SKIP
   params: mode, objname, data(type of object -> SQL_BACKUP_TABLE or SQL_BACKUP_VIEW or SQL_BACKUP_FUNC... )*/

#define SQL_BACKUP_DATA      04
/* Extract DATA -> .T. Write into Backup File / .F. SKIP
   params: mode, objname (filename), data( Recno() value ) */


#define SQL_BACKUP_ERROR    999
/* Error restoring DATA -> .T. Continue / .F. Cancel
   params: mode, objname (cSQL Command), data( line of error )

   See SQL_ERRORMSG() / SQL_ERRORNO() for get details about error
*/

*
* BACKUP Constants - Object Type for uData
*                    when mode is SQL_BACKUP_DDL
*
#define SQL_BACKUP_TABLE     01
#define SQL_BACKUP_VIEW      02
#define SQL_BACKUP_FUNC      03
#define SQL_BACKUP_SP        04
#define SQL_BACKUP_UNKNOWN   05
#define SQL_BACKUP_OBJECTS   {'TABLE','VIEW','FUNCTION', 'PROCEDURE','UNKNOWN'}

*
* SQLGetConnectionInfo() Constants
*
#define SQL_CONN_HANDLE      01
#define SQL_CONN_RDD         02
#define SQL_CONN_HOST        03
#define SQL_CONN_PORT        04
#define SQL_CONN_DB          05
#define SQL_CONN_USER        06
#define SQL_CONN_PASSWORD    07
#define SQL_CONN_FLAGS       08
#define SQL_CONN_SYSTEMID    09

/*
 * SQLGetDBInfo constants
 */
#define DBI_GETVERSION        00
#define DBI_GETALLTABLES      01
#define DBI_GETALLDBS         02
#define DBI_GETALLINDEXES     03
#define DBI_GETALLUSERS       04
#define DBI_GETALLCONNUSERS   05
#define DBI_GETSYSTEMID       06
#define DBI_GETSYSTEMIDSTR    07

/*
 * SQLGetConnectedUsers() constants
 */
#define CONN_USER             01
#define CONN_DB               02
#define CONN_PORT             03
#define CONN_SQL              04

/*
 * Table Stype
 */
#define TS_COMPLEX_SQL         2
#define TS_SINGLE_SQL          1

/*
 * Novos comandos que lhe auxiliarÆo no uso da fun‡Æo DBcreate()
 * Para maiores informa‡äes, consulte estes links em portugues:
 *
 *  MySQL link: http://dev.mysql.com/doc/refman/4.1/pt/create-table.html
 *  Post  link: http://pgdocptbr.sourceforge.net/pg80/sql-createtable.html
 */
#ifndef HB_110 
#command SQL ADD FIELD <cFieldName> <cType>(<nSize>[,<nDec>])  ;
            [DEFAULT <d>]        ;
            [<n:NOT NULL>]       ;
            [<u:UNIQUE>]         ;
            [<a:AUTO_INC,AUTOINC>]       ;
            [<p:PRIMARY_KEY>]    ;
             INTO <aStruct>   => ;
                                 ;
      AADD( <aStruct>, {<cFieldName>,;             // 1ø Nome do campo
                        <"cType">   ,;             // 2ø Tipo do campo, minimo 1¦ letra
                        <nSize>     ,;             // 3ø Tamanho do campo
                        iif(<.nDec.>,<nDec>,0),;   // 4ø Casas decimais
                           <.n.>    ,;             // 5ø .T. indica o flag NOT NULL
                           <.u.>    ,;             // 6ø .T. indica o flag UNIQUE
                           <.a.>    ,;             // 7ø .T. indica o flag AUTOINCREMENT
                           <.p.>    ,;             // 8ø .T. indica o flag PRIMARY KEY
                           <d>      ,;             // 9ø ExpressÆo DEFAULT para o campo
                           .F. ;                   //10ø .T. indica campo no formato SQL
                        } )

#command SQL ADD FIELD <cFieldName> TYPE <cType> ;
            [DEFAULT <d>]        ;
            [<n:NOT NULL>]       ;
            [<u:UNIQUE>]         ;
            [<a:AUTO_INC,AUTOINC>]       ;
            [<p:PRIMARY_KEY>]    ;
             INTO <aStruct>   => ;
                                 ;
      AADD( <aStruct>, {<cFieldName>,;             // 1ø Nome do campo
                        <"cType">   ,;             // 2ø Tipo do campo, minimo 1¦ letra
                                  0 ,;             // 3ø Tamanho do campo
                                  0 ,;             // 4ø Casas decimais
                           <.n.>    ,;             // 5ø .T. indica o flag NOT NULL
                           <.u.>    ,;             // 6ø .T. indica o flag UNIQUE
                           <.a.>    ,;             // 7ø .T. indica o flag AUTOINCREMENT
                           <.p.>    ,;             // 8ø .T. indica o flag PRIMARY KEY
                           <d>      ,;             // 9ø ExpressÆo DEFAULT para o campo
                           .T. ;                   //10ø .T. indica campo no formato SQL
                        } )

#endif
#endif

/* Eof */
