// Task 1: Grade Band Checker

#include <stdio.h>

int main() {
    float percentage;

    printf("Enter student's percentage: ");
    scanf("%f", &percentage);

    if (percentage < 0 || percentage > 100) {
        printf("Error: Percentage must be between 0 and 100.\n");
        return 0;
    }

    if (percentage >= 90) {
        printf("Grade: A\n");
        printf("Excellent! Keep up the outstanding work.\n");
    }
    else if (percentage >= 75) {
        printf("Grade: B\n");
        printf("Good work! Keep pushing.\n");
    }
    else if (percentage >= 60) {
        printf("Grade: C\n");
        printf("Nice effort! You can do even better.\n");
    }
    else if (percentage >= 45) {
        printf("Grade: D\n");
        printf("Don't give up. Practice more.\n");
    }
    else {
        printf("Grade: F\n");
        printf("Work harder and never stop learning.\n");
    }

    return 0;
}