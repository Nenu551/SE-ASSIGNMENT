#include <stdio.h>

int main() {

    int arr[10];
    int i, j;
    int max, min;
    int sum = 0;
    float mean;

    printf("Enter 10 integers:\n");

    for(i=0;i<10;i++){
        scanf("%d",&arr[i]);
    }

    max = min = arr[0];

    for(i=0;i<10;i++){

        if(arr[i]>max)
            max = arr[i];

        if(arr[i]<min)
            min = arr[i];

        sum += arr[i];
    }

    mean = sum / 10;

    for(i=0;i<9;i++){

        for(j=0;j<9-i;j++){

            if(arr[j]>arr[j+1]){

                int temp = arr[j];
                arr[j]=arr[j+1];
                arr[j+1]=temp;
            }
        }
    }

    printf("\nMaximum = %d",max);
    printf("\nMinimum = %d",min);
    printf("\nMean = %.2f",mean);

    printf("\nSorted Array:\n");

    for(i=0;i<10;i++)
        printf("%d ",arr[i]);

    if((mean-min)<(max-mean))
        printf("\nMean is closer to Minimum");

    else if((mean-min)>(max-mean))
        printf("\nMean is closer to Maximum");

    else
        printf("\nMean is exactly midway");

    return 0;
}