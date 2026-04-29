:- initialization(main, main).
:- use_module(auditoria_ti).

main :-
    Usuario = admin,
    Servidor = s1,
    Puerto = 443,
    evaluar_acceso(Usuario, Servidor, Puerto, Resultado),
    diagnostico_rapido(Usuario, Servidor, Puerto, CausaPrincipal),
    format("Consulta: ~w acceso a ~w:~w~n", [Usuario, Servidor, Puerto]),
    format("Resultado: ~w~n", [Resultado]),
    format("Primera falla critica (con corte): ~w~n", [CausaPrincipal]).
