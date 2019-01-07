%option noyywrap
%option yylineno
%{
    #include <stdlib.h>
    #include <string.h>
    #include "opt_compiler.tab.h"
%}

%x CMT

%%

"["             { BEGIN(CMT);       }
<CMT>"]"        { BEGIN(INITIAL);   }
<CMT>(\n|.)
<CMT><<EOF>>    { printf("Błąd: niezakończony komentarz.\n"); yyterminate(); }

"DECLARE"       { return DECLARE;   }
"IN"            { return IN;        }
"END"           { return END;       }

"IF"            { return IF;        }
"THEN"          { return THEN;      }
"ELSE"          { return ELSE;      }
"ENDIF"         { return ENDIF;     }

"WHILE"         { return WHILE;     }
"DO"            { return DO;        }
"ENDWHILE"      { return ENDWHILE;  }
"ENDDO"         { return ENDDO;     }

"FOR"           { return FOR;       }
"FROM"          { return FROM;      }
"TO"            { return TO;        }
"DOWNTO"        { return DOWNTO;    }

"READ"          { return READ;      }
"WRITE"         { return WRITE;     }

":="            { return ":=";      }
"="             { return "=";       }
"!="            { return "!="       }
"<"             { return "<";       }
">"             { return ">";       }
"<="            { return "<=";      }
">="            { return ">=";      }

"+"             { return "+";      }
"-"             { return "-";      }
"*"             { return "*";      }
"/"             { return "/";      }
"%"             { return "%";      }

[0-9]+          { yylval.str = (char *)strdup(yytext);
                    return num;    }
[_a-z]+         { yylval.str = (char *)strdup(yytext);
                    return pidentifier;    }

";"             { return ";";      }
[ \t\r\n]+
.

%%