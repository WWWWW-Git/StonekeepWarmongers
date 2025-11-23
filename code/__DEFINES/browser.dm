//Defines for the browser datum and its subtypes.

#define NULLABLE(condition) (condition || null)
#define PREVENT_CHARACTER_TRIM_LOSS(integer) (integer + 1) //thank you gummie
#define CHOICE_OK "UNDERSTOOD"

#define CHOICE_YES "DO SO"
#define CHOICE_NO "IT CAN'T BE"
#define CHOICE_NEVER "NEVER AGAIN"

#define CHOICE_CONFIRM "MAKE IT SO"
#define CHOICE_CANCEL "I DO NOT WANT"

#define DEFAULT_INPUT_CONFIRMATIONS list(CHOICE_CONFIRM, CHOICE_CANCEL)
#define DEFAULT_INPUT_CHOICES list(CHOICE_YES, CHOICE_NO)
