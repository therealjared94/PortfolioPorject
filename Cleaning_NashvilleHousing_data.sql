Select * 
From PorfolioProject.dbo.NashvilleHousing

------------------------------------------------------------------------------------------------

-- Standardize Date Format (SaleDate Column)
-- Convert Datetime format to just date, as the time does not matter. 
Select SaleDate, CONVERT(Date,Saledate)
From PorfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(Date,Saledate)

ALTER TABLE NashvilleHousing
Add SaleDate2 Date;

Update NashvilleHousing
SET SaleDate2 = Convert(Date,Saledate)


------------------------------------------------------------------------------------------------
-- Populate Property Address data

Select PropertyAddress
From PorfolioProject.dbo.NashvilleHousing
Where PropertyAddress is null
-- 29 records are NULL

Select *
From PorfolioProject.dbo.NashvilleHousing
order by ParcelID

-- ParcelID represents each unique properttyaddress, using Vlookup method to populate ID
-- Join the table with parcel ID the same but the UniqueID is different (not the same one)
-- By finding the duplicated Parcel ID. 

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From PorfolioProject.dbo.NashvilleHousing a
JOIN PorfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Update the property address with cross referenced parcelID
Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PorfolioProject.dbo.NashvilleHousing a
JOIN PorfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Expanding the address into individual columns (street name, state, ... ) 
-- Clearer information present

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as State
From PorfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(25);

SET ANSI_WARNINGS OFF
Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)
SET ANSI_WARNINGS ON;

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(25);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

-- For Owner address side
Select 
PARSENAME(REPLACE(Owneraddress,',','.'),3),
PARSENAME(REPLACE(Owneraddress,',','.'),2),
PARSENAME(REPLACE(Owneraddress,',','.'),1)
From PorfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(25);

SET ANSI_WARNINGS OFF
Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(Owneraddress,',','.'),3)
SET ANSI_WARNINGS ON;

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(25);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(Owneraddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(25);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(Owneraddress,',','.'),1)



-- Checking data field consistency 
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PorfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

-- Yes & No is majority, hence change all Y/N into Yes & No
Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 Else SoldAsVacant
	 END
From PorfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 Else SoldAsVacant
	 END




-- Remove Duplicates (Not recommended, best practice to keep all orginal data
Select *
From PorfolioProject.dbo.NashvilleHousing

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
				 PropertyAddress,
				 SalePrice,
				 SaleDate, 
				 LegalReference
				 ORDER BY 
					UniqueID 
					) row_num
From PorfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



-- Delete Unused Columns
-- Can remove both Owner, Property address & TaxDistrict
Select * 
From PorfolioProject.dbo.NashvilleHousing

ALTER TABLE PorfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PorfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate