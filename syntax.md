### Modules
```bash
(mod (first second)
(+ first second)
)
```
####  Defines a constant value with a name.
 ```
 (defconstant ORDER_OF_MAGNITUDE 10)
 ```   

#### In the example we have use the constant and call the function mod with the constant value.
```bash
;;; Raises the number by one order of magnitude.

(mod (value)
    ; Defines a constant value with a name.
    (defconstant ORDER_OF_MAGNITUDE 10)

    ; Defines a function that can be called with a value.
    (defun raise_magnitude (value)
        (* value ORDER_OF_MAGNITUDE)
    )

    ; Calls the previously defined function.
    (raise_magnitude value)
)
```

