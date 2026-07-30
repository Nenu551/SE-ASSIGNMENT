// Task 4: Personal Expense Logger

#include <stdio.h>

struct Expense {
    char category[30];
    float amount;
};

int main() {

    struct Expense e[10];
    int count = 0;
    int choice;
    float total;

    FILE *fp;

    do {

        printf("\n------ Expense Logger ------\n");
        printf("1. Add Expense\n");
        printf("2. View All Expenses\n");
        printf("3. Save & Exit\n");

        printf("Enter Choice : ");
        scanf("%d", &choice);

        switch (choice) {

            case 1:

                if (count >= 10) {
                    printf("Storage Full!\n");
                    break;
                }

                printf("Enter Category : ");
                scanf(" %[^\n]", e[count].category);

                printf("Enter Amount : ");
                scanf("%f", &e[count].amount);

                count++;

                break;

            case 2:

                total = 0;

                printf("\n-------------------------------\n");
                printf("%-20s %-10s\n", "Category", "Amount");
                printf("-------------------------------\n");

                for (int i = 0; i < count; i++) {

                    printf("%-20s %.2f\n",
                           e[i].category,
                           e[i].amount);

                    total += e[i].amount;
                }

                printf("-------------------------------\n");
                printf("Total = %.2f\n", total);

                break;

            case 3:

                fp = fopen("expenses.txt", "w");

                if (fp == NULL) {
                    printf("File cannot be opened.\n");
                    return 0;
                }

                for (int i = 0; i < count; i++) {

                    fprintf(fp,
                            "%s,%.2f\n",
                            e[i].category,
                            e[i].amount);
                }

                fclose(fp);

                printf("Expenses saved successfully in expenses.txt\n");

                break;

            default:

                printf("Invalid Choice!\n");
        }

    } while (choice != 3);

    return 0;
}