# User stories and acceptance criteria

Use fictional usernames and sample books when testing. This is a shared classroom
catalog, without sign-in or private collections. A user record represents a reader;
it is not an authenticated account.

## 1. Browse the collection

As a reader, I can open Home to see User Books and navigate to Books and Users.

- `/` displays the heading **User Books** and links to Books, Users, and New user book.
- Each association displays the selected username and book title.
- `/books` lists saved books with show, edit, and delete links.
- Every form/detail page contains a Home link.

## 2. Add a book

As a reader, I can save a book with its title, author, price, and published date.

- On Books, choose New book. Enter Dune, Frank Herbert, 12.99, and August 1, 1965.
- The date uses year, month, and day dropdowns.
- Create Book saves one record, returns Home, and displays “Book was successfully created.”
- Show this book displays all four values, including $12.99 and 1965-08-01.
- A blank or whitespace-only title shows a validation error and saves no record.
- Title is required. Author, price, and published date may be blank for legacy
  title-only books. A supplied price must be numeric, nonnegative, and below 100,000,000.

## 3. Edit a book

As a reader, I can correct saved book details.

- Edit this book prepopulates the current attributes.
- Update Book persists changes, returns Home, and displays a success notice.
- A blank title or invalid price shows errors and leaves the saved record unchanged.

## 4. Delete a book

As a reader, I can review a confirmation before deleting a book.

- Delete this book opens a separate page naming the book.
- Cancel returns to Books without deleting anything.
- Confirm delete submits DELETE, removes the book and its associations, returns
  Home, and shows a deletion notice. User records remain.

## 5. Manage readers

As a catalog organizer, I can create, list, show, edit, and delete users.

- A nonblank username saves successfully; a blank username shows an error.
- Changes appear in Users and in linked User Books records.
- Deleting a user removes their associations and retains the books.

## 6. Associate users and books

As a catalog organizer, I can assign multiple books to a user and a book to multiple users.

- New user book shows dropdowns of existing users and books, sorted by username/title.
- Selecting both records creates a UserBook and returns Home with a success notice.
- Show and Edit use readable usernames and titles rather than only numeric IDs.
- Missing selections and duplicate user/book pairs show errors and create no record.
- Edit changes the association. Deleting an association retains both its user and book.

## Deployment acceptance

Run these stories against review, staging, and production. Record each actual URL,
commit, and result. Confirm `/up` responds successfully and records persist after
an application restart. Do not submit an undeployed URL as evidence of success.
