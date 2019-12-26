Ideas for Forms:

I think the TurboTax process is really good.  
Pretend we have a form that is 10 fields long. 
Each "page" of the form can display "x" fields.
Each field gets validated independently and is able to influence other fields.
Once all fields in a "page" are passing validation, let the user proceed to the next page (or submit on last page).

### Properties of Fields
  - Required
    - True means the user is forced to enter a value
    - False means the user doesn't have to enter a value

  - Relevant
    - True means the field validation should be taken into account when validating the page/form.
    - False means the validation result should be ignored from page/form validation.

  - ReadOnly
    - True means the user cannot change the value
    - False means the user has the ability to change the value
    
  - Visible
    - True means the field is visible
    - False means the field is hidden

  - Type
    - It should support any HTML input type and attributes for those types.
    - Maybe just pass type_ as a string?
    - The DevDocs site does a good job of explaining Input element types.
    - Maybe down the road I can just create some concrete supported types with supported props.

  - Attributes
    - Maybe pass attributes in a List String?

  - Value
    - The String version of the value
  

### Validation

When does validation occur?: 
  - When the user clicks out of the field. (validate the field the user is leaving) 
  - When the user tries to leave the "page". (check for missing fields) 

How are validation results displayed?:
  - Success: field gets a green border, maybe a small checkbox icon on the left or right?
  - Error: field gets a red border, maybe a small 'X' on the left or right?
    - Error text should get displayed under the field.

### API ???

-- Types

Form (List Page) SubmitAction

Page (List Fields)

Field Type (List Attributes) Validator

Validator -> FormMsg

-- FormMsg

FieldOk Form
FieldErr Form
Submit



