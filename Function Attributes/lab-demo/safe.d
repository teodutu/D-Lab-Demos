import std;

void unsafeFunc(void* p) @trusted
{
	*((cast(int*) p) + 2) = 69;
}

void main() @safe
{
	int[] arr = [1, 2, 3];

	unsafeFunc(&arr[0]);
	writeln(arr);
}
