//
//  Matrix.h
//  Matrix
//
//  Created by Yan Const on 11/7/13.
//  Copyright (c) 2013 Ioannis Chatzikonstantinou. All rights reserved.
//

#import "YCMatrix+Manipulate.h"

@implementation YCMatrix (Manipulate)

+ (YCMatrix *)matrixFromRows:(NSArray *)rows
{
    
}

+ (YCMatrix *)matrixFromColumns:(NSArray *)columns
{
    
}

- (YCMatrix *)getRow:(int) rowNumber
{
    if (rowNumber > self->rows - 1)
    {
        @throw [NSException exceptionWithName:@"IndexOutOfBoundsException"
                                       reason:@"Row index input is out of bounds."
                                     userInfo:nil];
    }
    // http://stackoverflow.com/questions/5850000/how-to-split-array-into-two-arrays-in-c
    int rowIndex = rowNumber * self->columns;
    YCMatrix *rowmatrix = [YCMatrix matrixOfRows:1 Columns:self->columns];
    double *row = rowmatrix->matrix;
    memcpy(row, self->matrix + rowIndex, self->columns * sizeof(double));
    return rowmatrix;
}
- (void)setRow:(int)rowNumber Value:(YCMatrix *)rowValue
{
    if (rowNumber > self->rows - 1)
    {
        @throw [NSException exceptionWithName:@"IndexOutOfBoundsException"
                                       reason:@"Row index input is out of bounds."
                                     userInfo:nil];
    }
    if (rowValue->rows != 1 || rowValue->columns != columns)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    memcpy(self->matrix + columns * rowNumber, rowValue->matrix, columns * sizeof(double));
}
- (NSArray *)RowsAsNSArray
{
    NSMutableArray *rowsArray = [NSMutableArray arrayWithCapacity:rows];
    for (int i=0; i<rows; i++)
    {
        [rowsArray addObject: [self getRow:i]];
    }
    return rowsArray;
}
- (YCMatrix *)getColumn:(int) colNumber
{
    if (colNumber > self->columns - 1)
    {
        @throw [NSException exceptionWithName:@"IndexOutOfBoundsException"
                                       reason:@"Column index input is out of bounds."
                                     userInfo:nil];
    }
    YCMatrix *columnmatrix = [YCMatrix matrixOfRows:self->rows Columns:1];
    double *column = columnmatrix->matrix;
    for (int i=0; i<self->rows; i++)
    {
        column[i] = self->matrix[i*self->columns + colNumber];
    }
    return columnmatrix;
}
- (void)setColumn:(int)colNumber Value:(YCMatrix *)columnValue
{
    if (colNumber > self->columns - 1)
    {
        @throw [NSException exceptionWithName:@"IndexOutOfBoundsException"
                                       reason:@"Column index input is out of bounds."
                                     userInfo:nil];
    }
    if (columnValue->columns != 1 || columnValue->rows != rows)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    for (int i=0; i<rows; i++)
    {
        self->matrix[columns*i + colNumber] = columnValue->matrix[i];
    }
}
- (NSArray *)ColumnsAsNSArray // needs some speed improvement
{
    NSMutableArray *columnsArray = [NSMutableArray arrayWithCapacity:columns];
    for (int i=0; i<columns; i++)
    {
        [columnsArray addObject: [self getColumn:i]];
    }
    return columnsArray;
}
- (YCMatrix *)addRowToAllRows:(YCMatrix *)addend
{
    if (addend->rows != 1 || addend->columns != self->columns)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    YCMatrix *sum = [YCMatrix matrixFromMatrix:self];
    double *sumarray = sum->matrix;
    double *addendarray = addend->matrix;
    int cols = self->columns;
    int rws = self->rows;
    for (int i=0; i<rws; i++)
    {
        for (int j=0; j<cols; j++)
        {
            sumarray[i*cols + j] += addendarray[j]; //j!
        }
    }
    return sum;
}
- (YCMatrix *)subtractRowFromAllRows:(YCMatrix *)subtrahend
{
    return [self addRowToAllRows:[subtrahend negate]];
}
- (YCMatrix *)multiplyAllRowsWithRow:(YCMatrix *)factor{
    if (factor->rows != 1 || factor->columns != self->columns)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    YCMatrix *product = [YCMatrix matrixFromMatrix:self];
    double *productarray = product->matrix;
    double *factorarray = factor->matrix;
    int cols = self->columns;
    int rws = self->rows;
    for (int i=0; i<rws; i++)
    {
        for (int j=0; j<cols; j++)
        {
            productarray[i*cols + j] *= factorarray[j]; //j!
        }
    }
    return product;
}
- (YCMatrix *)addColumnToAllColumns:(YCMatrix *)addend
{
    if (addend->columns != 1 || addend->rows != self->rows)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    YCMatrix *sum = [YCMatrix matrixFromMatrix:self];
    double *sumarray = sum->matrix;
    double *addendarray = addend->matrix;
    int cols = self->columns;
    int rws = self->rows;
    for (int i=0; i<rws; i++)
    {
        for (int j=0; j<cols; j++)
        {
            sumarray[i*cols + j] += addendarray[i]; //i!
        }
    }
    return sum;
}
- (YCMatrix *)subtractColumnFromAllColumns:(YCMatrix *)subtrahend
{
    return [self addColumnToAllColumns:[subtrahend negate]];
}
- (YCMatrix *)multiplyAllColumnsWithColumn:(YCMatrix *)factor
{
    if (factor->columns != 1 || factor->rows != self->rows)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    YCMatrix *product = [YCMatrix matrixFromMatrix:self];
    double *productarray = product->matrix;
    double *factorarray = factor->matrix;
    int cols = self->columns;
    int rws = self->rows;
    for (int i=0; i<rws; i++)
    {
        for (int j=0; j<cols; j++)
        {
            productarray[i*cols + j] *= factorarray[i]; //i!
        }
    }
    return product;
}
- (YCMatrix *)appendRow:(YCMatrix *)newRow
{
    if (newRow->rows != 1 || newRow->columns != columns)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    double *newMatrix = malloc(columns * (rows + 1) * sizeof(double));
    memcpy(newMatrix, self->matrix, columns * rows * sizeof(double));
    memcpy(newMatrix + columns*rows, newRow->matrix, columns * sizeof(double));
    return [YCMatrix matrixFromArray:newMatrix Rows:rows + 1 Columns:columns];
}
- (YCMatrix *)appendColumn:(YCMatrix *)newColumn
{
    if (newColumn->columns != 1 || newColumn->rows != rows)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    double *newMatrix = malloc((columns + 1) * rows * sizeof(double));
    int newCols = columns + 1;
    for (int i=0; i < rows; i++)
    {
        memcpy(newMatrix + newCols * i, self->matrix + columns * i, columns * sizeof(double));
        newMatrix[newCols * i + columns] = newColumn->matrix[i];
    }
    return [YCMatrix matrixFromArray:newMatrix Rows:rows Columns:columns + 1];
}
- (YCMatrix *)removeRow:(int)rowNumber
{
    double newRows = rows - 1;
    if (rowNumber > newRows)
    {
        @throw [NSException exceptionWithName:@"IndexOutOfBoundsException"
                                       reason:@"Row index input is out of bounds."
                                     userInfo:nil];
    }
    double *newMatrix = malloc(columns * newRows * sizeof(double));
    for (int i=0; i < newRows; i++) // should count to one-less than rows, so newRows
    {
        int idx = i >= rowNumber ? i+1 : i;
        memcpy(newMatrix + columns * i, self->matrix + columns * idx, columns * sizeof(double));
    }
    return [YCMatrix matrixFromArray:newMatrix Rows:newRows Columns:columns];
}
- (YCMatrix *)removeColumn:(int)columnNumber
{
    if (columnNumber > self->columns - 1)
    {
        @throw [NSException exceptionWithName:@"IndexOutOfBoundsException"
                                       reason:@"Column index input is out of bounds."
                                     userInfo:nil];
    }
    double newCols = columns - 1;
    double *newMatrix = malloc(newCols * rows * sizeof(double));
    for (int i=0; i < rows; i++)
    {
        memcpy(newMatrix, self->matrix, columnNumber * sizeof(double));
        memcpy(newMatrix + columnNumber, self->matrix + columnNumber + 1, (newCols - columnNumber) * sizeof(double));
    }
    return [YCMatrix matrixFromArray:newMatrix Rows:rows Columns:newCols];
}
- (YCMatrix *)appendValueAsRow:(double)value
{
    if(columns != 1)
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"appendValueAsRow can only be performed on vectors."
                                     userInfo:nil];
    int newRows = rows + 1;
    double *newArray = malloc(columns * newRows * sizeof(double));
    memcpy(newArray, matrix, columns * rows * sizeof(double));
    newArray[columns * newRows - 1] = value;
    return [YCMatrix matrixFromArray:newArray Rows:newRows Columns:columns];
}

// Fisher-Yates Inside-out Shuffle
- (YCMatrix *)newFromShufflingRows
{
    
}

// Fisher-Yates Shuffle
- (void)shuffleRows
{
    
}

// Fisher-Yates Inside-out Shuffle
- (YCMatrix *)newFromShufflingColumns
{
    
}

// Fisher-Yates Shuffle
- (void)shuffleColumns
{
    
}

@end
