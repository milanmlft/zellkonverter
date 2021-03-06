% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/konverter.R
\name{AnnData-Conversion}
\alias{AnnData-Conversion}
\alias{AnnData2SCE}
\alias{SCE2AnnData}
\title{Convert AnnData between and SingleCellExperiment}
\usage{
AnnData2SCE(adata, skip_assays = FALSE, hdf5_backed = TRUE)

SCE2AnnData(sce, X_name = NULL, skip_assays = FALSE)
}
\arguments{
\item{adata}{A \strong{reticulate} reference to a Python AnnData object.}

\item{skip_assays}{Logical scalar indicating whether to skip conversion of
any assays in \code{sce} or \code{adata}, replacing them with empty sparse matrices
instead.}

\item{hdf5_backed}{Logical scalar indicating whether HDF5-backed matrices
in \code{adata} should be represented as HDF5Array objects. This assumes that
\code{adata} is created with \code{backed="r"}.}

\item{sce}{A \linkS4class{SingleCellExperiment} object.}

\item{X_name}{Name of the assay to use as the primary matrix (\code{X}) of the
AnnData object. If \code{NULL}, the first assay of \code{sce} will be used by default.}
}
\value{
\code{AnnData2SCE()} will return a \linkS4class{SingleCellExperiment}
containing the equivalent data from \code{adata}.

\code{SCE2AnnData()} will return a \strong{reticulate} reference to an AnnData object
containing the content of \code{sce}.
}
\description{
Conversion between Python AnnData objects and
\linkS4class{SingleCellExperiment} objects.
}
\details{
These functions assume that an appropriate Python environment has already
been loaded. As such, they are largely intended for developer use, most
typically inside a \strong{basilisk} context.

The conversion is not entirely lossless. The current mapping is shown below
(also at \url{https://tinyurl.com/AnnData2SCE}):

\if{html}{\figure{AnnData2SCE.png}{options: width=800, alt="SCE-AnnData map"}}
\if{latex}{\figure{AnnData2SCE.png}{options: width=5in}}

In \code{SCE2AnnData()}, matrices are converted to a \strong{numpy}-friendly format.
Sparse matrices are converted to \linkS4class{dgCMatrix} objects while all
other matrices are converted into ordinary matrices. If \code{skip_assays = TRUE},
empty sparse matrices are created instead and the user is expected to fill in
the assays on the Python side.

For \code{AnnData2SCE()}, a warning is raised if there is no corresponding R format
for a matrix in the AnnData object, and an empty sparse matrix is created
instead as a placeholder. If \code{skip_assays = NA}, no warning is emitted
but variables are created in the \code{\link[=int_metadata]{int_metadata()}} of the output to specify
which assays were skipped.

If \code{skip_assays = TRUE}, empty sparse matrices are created for all assays,
regardless of whether they might be convertible to an R format or not.
In both cases, the user is expected to fill in the assays on the R side,
see \code{\link[=readH5AD]{readH5AD()}} for an example.

We attempt to convert between items in the \linkS4class{SingleCellExperiment}
\code{\link[=metadata]{metadata()}} slot and the \code{AnnData} \code{uns} slot. If an item cannot be
converted a warning will be raised.

Values stored in the \code{varm} slot of an \code{AnnData} object are stored in a
column of \code{\link[=rowData]{rowData()}} in a \linkS4class{SingleCellExperiment}
as a \linkS4class{DataFrame} of matrices. No attempt is made to transfer this
information when converting from \linkS4class{SingleCellExperiment} to
\code{AnnData}.
}
\examples{
if (requireNamespace("scRNAseq", quietly = TRUE)) {
    library(basilisk)
    library(scRNAseq)
    seger <- SegerstolpePancreasData()

    # These functions are designed to be run inside
    # a specified Python environment
    roundtrip <- basiliskRun(fun = function(sce) {
        # Convert SCE to AnnData:
        adata <- zellkonverter::SCE2AnnData(sce)

        # Maybe do some work in Python on 'adata':
        # BLAH BLAH BLAH

        # Convert back to an SCE:
        zellkonverter::AnnData2SCE(adata)
    }, env = zellkonverter:::anndata_env, sce = seger)
}

}
\seealso{
\code{\link[=writeH5AD]{writeH5AD()}} and \code{\link[=readH5AD]{readH5AD()}} for dealing directly with H5AD files.
}
\author{
Luke Zappia

Aaron Lun
}
