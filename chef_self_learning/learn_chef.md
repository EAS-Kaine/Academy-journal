# Learning Chef  
This directory is dedicated to documenting things learned, resources used and code produced whilst familiarising myself with the chef platform.

## Resources
[Learning Chef: A Guide to Configuration Management and Automation](https://books.google.co.uk/books/about/Learning_Chef.html?id=LpY8BQAAQBAJ&source=kp_book_description&redir_esc=y) & [its companion repo](https://github.com/learningchef/learningchef-code)  

## Notes

Chef steers you toward using absolute paths in recipes because it would be dif‐
ficult to specify consistent file locations using relative paths.  

The file resource performs the :create action by default, but you can override this
default with the :delete action instead  

### recipe
A set of instructions written in a Ruby DSL that indicate the desired configuration
to Chef.
### resource
A cross-platform abstraction for something managed by Chef (such as a file). Re‐
sources are the building blocks from which you compose Chef code.
### attribute
Parameters passed to a resource

### Test Kitchen
Simulate production environments by sandboxing.

### Ohai
Aggregates machine information to be used when configuring node.