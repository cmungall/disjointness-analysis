:- use_module(library(index_util)).
:- use_module(library(sparqlprog/dataframe)).

ix :- materialize_index(violation(+,+,+,+,+)).


violation(N,C,A1,A2,D) :-
        disjoint_set_member(N,A1x),
        disjoint_set_member(N,A2x),
        A1x @< A2x,
        ensure_uri(A1x,A1),
        ensure_uri(A2x,A2),
        debug(disjoint_sets,'Testing ~w vs ~w in ~w',[A1,A2,N]),
        is_violation(C,A1,A2),
        disjoint_set(N,D).

is_violation(C,A1,A2) :-
        rdfs_subclass_of(C,A1),
        rdfs_subclass_of(C,A2).

violation_nr(N,C,A1,A2,D) :-
        violation(N,C,A1,A2,D),
        \+ ((is_violation(C2,A1,A2),
             rdfs_subclass_of(C,C2),
             C\=C2)).

dataframe:dataframe(violation,
                    [[set=N,
                      violation_class=C,
                      ancestor1=A1,
                      ancestor2=A2,
                      set_description=D]-violation_nr(N,C,A1,A2,D),
                     [genus=G]-class_genus(C,G),
                     [differentia_rel=R,
                      differentia_filler=Y]-class_differentia(C,R,Y),
                     [ancestor_genus=G]-(rdfs_subclass_of(C,C2),class_genus(C2,G)),
                     [ancestor_differentia_rel=R]-(rdfs_subclass_of(C,C2),class_differentia(C2,R,_))
                    ],
                    [description('pairwise violations from disjointness sets'),
                     entity(genus),
                     entity(ancestor_genus),
                     entity(violation_class),
                     entity(differentia_rel),
                     entity(ancestor_differentia_rel),
                     entity(differentia_filler),
                     entity(ancestor1),
                     entity(ancestor2)]).

                     


        
        


        
