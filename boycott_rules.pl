%  Program Description: This program is a Prolog program that helps the user to manage his orders and items.
% Last Modification Date: 27/3/2024
% First author - ID : Ahmed Mohamed Hany / 20210038
% Second author - ID : Tawfik Mohamed Khalil / 20211024
% Third author - ID : Salma Mohammed Mahmoud / 20210161
% Under The Supervision of: Dr. Khaled Tawfik

:-consult(data).
:-dynamic item/3.
:-dynamic alternative/2.
:-dynamic boycott_company/2.


len([],0).
len([_|Tail], N):-
    len(Tail, TmpN),
    N is TmpN+1.

my_append([], L, L).
my_append([H|T], L2, [H|NT]):-
    my_append(T, L2, NT).

my_member(X, [X|_]).
my_member(X, [_|T]):-
    my_member(X, T).


% Problem 1
checkExist(ORDER,LIST):-
    my_member(ORDER,LIST).

list_orders(CUSTOMER_NAME,LIST):-
    customer(CID,CUSTOMER_NAME),
    orders_list(CID,LIST,[]).


orders_list(CID,LIST,TMP):- 
    order(CID,ORDER_ID,ITEMS),
    X = order(CID,ORDER_ID,ITEMS), 
    not(checkExist(X,TMP)), !,
    orders_list(CID,LIST,[X|TMP]).

orders_list(_,LIST,LIST).


% Problem 2
countOrdersOfCustomer(UserName, Count):-
    list_orders(UserName, Orders),
    len(Orders, Count).


% Problem 3
getItemsInOrderById(Name,Ido,List):-     
    customer(IdC,Name),order(IdC,Ido,List).

%  Problem 4
getNumOfItems(UserName, OrderID, Count):-
    getItemsInOrderById(UserName,OrderID,List),
    len(List, Count).

% Problem 5
calcPriceOfOrder(UserName, OrderID, TotalPrice):-
    getItemsInOrderById(UserName,OrderID,List),
    calcOrder(List,TotalPrice).

% Problem 6
isBoycott(ITEM_NAME):-
    item(ITEM_NAME, X, _) , boycott_company(X, _).

isBoycott(COMPANY_NAME):-
    boycott_company(COMPANY_NAME, _).

% Problem 7
whyToBoycott(ItemName,Justification):-
     item(ItemName,CoName,_),boycott_company(CoName,Justification).
     
whyToBoycott(CoName,Justification):-     
    boycott_company(CoName,Justification).

% Problem 8
removeBoycottItemsFromAnOrder(USER_NAME,ORDER_ID,RESULT):-
    customer(CID,USER_NAME), order(CID,ORDER_ID,L), deleteIfBoycott(L,RESULT).

deleteIfBoycott([], []).
deleteIfBoycott([H|T], [H|NewItems]) :-
    not(isBoycott(H)),
    deleteIfBoycott(T, NewItems).

deleteIfBoycott([H|T], NewItems) :-
    isBoycott(H),
    deleteIfBoycott(T, NewItems).

% Problem 9
chkAlt(P,Repla):-
    alternative(P,Repla).


replaceItem([], []).
replaceItem([H|T], [NewItem|NewItems]):-
    chkAlt(H, NewItem),
    replaceItem(T, NewItems).

replaceItem([H|T], [H|NewItems]):-
    \+ chkAlt(H, _),
    replaceItem(T, NewItems).

 

replaceBoycottItemsFromAnOrder(UserName, OrderID, NewList):-
    customer(CustomerId, UserName),
    order(CustomerId, OrderID, Items),
    replaceItem(Items, NewList).

% Problem 10
calcOrder([],0).
calcOrder([H|T],TotalPrice):-
    item(H,_,P),
    calcOrder(T,Price),
    TotalPrice is P+Price.


getAltern([],_).
getAltern([H|T],L):-
    getAltern(T,R),
    chkAlt(H,Alt),
    L = [Alt|R].


calcPriceAfterReplacingBoycottItemsFromAnOrder(CustomerName,OrderId, ListAfterReplacement, TotalPrice):-
    getItemsInOrderById(CustomerName,OrderId,List),
    replaceItem(List,ListAfterReplacement),
    calcOrder(ListAfterReplacement,TotalPrice).

% Problem 11

getTheDifferenceInPriceBetweenItemAndAlternative(Item, A, DiffPrice):-
    item(Item, _, Price),
    alternative(Item, A),
    item(A, _, APrice),
    DiffPrice is Price - APrice.

% Problem 12
add_item(ItemName, CompanyName, Price):-
    assert(item(ItemName, CompanyName, Price)).

add_alternative(ItemName, AlternativeName):- 
    assert(alternative(ItemName, AlternativeName)).

add_boycott_company(CompanyName, Justification):-
    assert(boycott_company(CompanyName, Justification)).

remove_item(ItemName, CompanyName, Price):-
    retract(item(ItemName, CompanyName, Price)).

remove_alternative(ItemName, AlternativeName):-
    retract(alternative(ItemName, AlternativeName)).

remove_boycott_company(CompanyName, Justification):-
    retract(boycott_company(CompanyName, Justification)).

