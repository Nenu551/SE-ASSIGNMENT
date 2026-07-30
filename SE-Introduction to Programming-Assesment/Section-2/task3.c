// Task 3: Student Record Manager

#include <stdio.h>

struct Student {
    char name[50];
    int rollno;
    float marks;
    char grade;
};

void assignGrade(struct Student *s) {

    if (s->marks >= 90)
        s->grade = 'A';
    else if (s->marks >= 75)
        s->grade = 'B';
    else if (s->marks >= 60)
        s->grade = 'C';
    else if (s->marks >= 45)
        s->grade = 'D';
    else
        s->grade = 'F';
}

void printTopper(struct Student s[], int n) {

    int topper = 0;

    for (int i = 1; i < n; i++) {

        if (s[i].marks > s[topper].marks)
            topper = i;
    }

    printf("\nTop Performer\n");
    printf("Name : %s\n", s[topper].name);
    printf("Marks : %.2f\n", s[topper].marks);
}

int main() {

    struct Student s[3];

    for (int i = 0; i < 3; i++) {

        printf("\nEnter Details of Student %d\n", i + 1);

        printf("Name : ");
        scanf(" %[^\n]", s[i].name);

        printf("Roll No : ");
        scanf("%d", &s[i].rollno);

        printf("Marks : ");
        scanf("%f", &s[i].marks);

        assignGrade(&s[i]);
    }

    printf("\n-----------------------------------------------\n");
    printf("%-20s %-10s %-10s %-10s\n",
           "Name", "Roll", "Marks", "Grade");
    printf("-----------------------------------------------\n");

    for (int i = 0; i < 3; i++) {

        printf("%-20s %-10d %-10.2f %-10c\n",
               s[i].name,
               s[i].rollno,
               s[i].marks,
               s[i].grade);
    }

    printTopper(s, 3);

    return 0;
}