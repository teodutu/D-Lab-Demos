import std;

auto foo(ref int xval)
{
    struct S { int x; }
    return S(++xval);
}   

void tempFunc(T, U)(T arg)
{
    writeln("template type: ", T.stringof);
    writeln("template arg: ", arg);
}

void bar(T)(auto ref T arg)
{
	++arg;
}

void main()
{
    int a = 2;
    auto s = foo(a);
    writeln("s = ", s);
    writeln("a = ", a);

    tempFunc!(int, double)(3);
    tempFunc!(int, double)(2);
    tempFunc!(string, int)("pula");
   
    bar(a);
    writeln("a = ", a);
    bar(2);
    writeln("a = ", a);
}
