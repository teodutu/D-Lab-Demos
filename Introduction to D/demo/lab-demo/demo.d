struct S
{
        int x, y;
}

class C
{
       int x, y;
}

void foo(ref S s)
{
        s.x = 69;
}

void foo(C c)
{
        c.x = 69;
}

int main()
{
        import std.stdio;

        writeln("manele", 1, " ", 2.6);

        int[2] arr = void;

        writeln(arr.length);
        writeln(arr);

        S a = {2, 3};
        foo(a);
        writeln(a);

        C c = new C();
        c.x = 2;
        c.y = 3;
        foo(c);
        writeln(c.x);

        string[string] aa;
        aa["gigel"] = "dorel";

        auto found = "dorel" in aa;
        writeln(found);

        found = "gigel" in aa;
        writeln(found);
        *found = "abc";
        writeln(aa["gigel"]);

        int[10] x;
        int[] b = x;
        writeln(x.ptr == b.ptr);

        return 0;
}
