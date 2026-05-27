#ifndef TYPEDEFS_H
#define TYPEDEFS_H

#include <stdint.h>
#include <stdbool.h>
#include "raylib.h"

typedef int8_t i8;
typedef int16_t i16;
typedef int32_t i32;
typedef int64_t i64;
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
typedef float f32;
typedef double f64;
typedef const char *string;
typedef void *pointer;

#endif // TYPEDEFS_H

int main()
{
    // strings

    string h_filename = "codegen/include/path/to/module.h";

    string c_filename = "codegen/src/path/to/module.c";

    string include_data = TextFormat(
        "#ifndef MODULE_H\n"
        "#define MODULE_H\n\n"
        "void InitModule(void);\n\n"
        "#endif // MODULE_H\n");

    string source_data = TextFormat(
        "#include \"module.h\"\n\n"
        "void InitModule(void)\n"
        "{\n"
        "    // Todo: implement\n"
        "}\n");

    MakeDirectory("codegen/include/path/to");
    MakeDirectory("codegen/src/path/to");

    // saving files
    if (SaveFileText(h_filename, include_data) && SaveFileText(c_filename, source_data))
    {
        TraceLog(LOG_INFO, "worked \n");
    }
    else
    {
        TraceLog(LOG_ERROR, "didnt work \n");
        return 1;
    }

    return 0;
}
/** to do
 *  automatically generate header and source files for a module
 *  lower to upper
 *  and change / to _ etc
 */
