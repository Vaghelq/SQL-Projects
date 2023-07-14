select * 
from NashvilleHousing

--standarized data format

select SaleDateConverted, Convert(Date,SaleDate)
from NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT(date, SaleDate)

Alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(date, SaleDate)


--Populate property Address Data

select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.propertyaddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]


--Breaking out address into Individual Columns (Address, city, state)
select PropertyAddress
from NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
 ,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress)) as Address
from NashvilleHousing

Alter table NashvilleHousing
Add PropertySplitAddress nvarchar(255)

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

Alter table NashvilleHousing
Add PropertySplitCity nvarchar(255)

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress)) 

select *
from NashvilleHousing



select OwnerAddress
from NashvilleHousing

select
PARSENAME(Replace(OwnerAddress,',','.'), 3),
PARSENAME(Replace(OwnerAddress,',','.'), 2),
PARSENAME(Replace(OwnerAddress,',','.'), 1)
from NashvilleHousing


Alter table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'), 3)

Alter table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'), 2)

Alter table NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'), 1)

select*
from NashvilleHousing

--Change Y and N to Yes And No in "Sold As Vacant" Field

select distinct(soldAsVacant), COUNT(soldasVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2

select soldasvacant
, case when SoldAsVacant ='Y' then 'Yes'
 when SoldAsVacant ='N' then 'No'
 Else SoldAsVacant
 End
from NashvilleHousing


Update NashvilleHousing
set soldasvacant= case when SoldAsVacant ='Y' then 'Yes'
 when SoldAsVacant ='N' then 'No'
 Else SoldAsVacant

 --remove duplicates
 with row_numCTE as(
 select *,
 Row_Number() over(
 Partition by ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  Order by UniqueID
			  ) row_num
from NashvilleHousing
--order by ParcelID
)
select *
from row_numCTE
where row_num >1
--order by PropertyAddress


--Delete Unused Columns
select *
from NashvilleHousing

Alter table nashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter table nashvilleHousing
Drop column SaleDate