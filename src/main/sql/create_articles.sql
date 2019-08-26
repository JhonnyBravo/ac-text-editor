CREATE TABLE articles
(
    id Counter(1,1) CONSTRAINT pk PRIMARY KEY,
    title Text(100),
    contents Memo
);
