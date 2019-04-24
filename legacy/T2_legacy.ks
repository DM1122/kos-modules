//TEST SCRIPT #2//
set mylist to list("red","green","blue","yellow","orange","black","white","brown","purple","silver","gold").
set mylist_iter to mylist:iterator.
mylist_iter:reset().
print mylist_iter:index.
mylist_iter:next().
print mylist[mylist_iter:index].
print mylist_iter:index.
mylist_iter:next().
print mylist[mylist_iter:index].
print mylist_iter:index.
mylist_iter:next().
print mylist[mylist_iter:index].
print mylist_iter:index.

wait until false.