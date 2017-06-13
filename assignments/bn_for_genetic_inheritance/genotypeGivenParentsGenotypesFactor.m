function genotypeFactor = genotypeGivenParentsGenotypesFactor(numAlleles, genotypeVarChild, genotypeVarParentOne, genotypeVarParentTwo)
% This function computes a factor representing the CPD for the genotype of
% a child given the parents' genotypes.

% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES

% When writing this function, make sure to consider all possible genotypes
% from both parents and all possible genotypes for the child.

% Input:
%   numAlleles: int that is the number of alleles
%   genotypeVarChild: Variable number corresponding to the variable for the
%   child's genotype (goes in the .var part of the factor)
%   genotypeVarParentOne: Variable number corresponding to the variable for
%   the first parent's genotype (goes in the .var part of the factor)
%   genotypeVarParentTwo: Variable number corresponding to the variable for
%   the second parent's genotype (goes in the .var part of the factor)
%
% Output:
%   genotypeFactor: Factor in which val is probability of the child having
%   each genotype (note that this is the FULL CPD with no evidence
%   observed)

% The number of genotypes is (number of alleles choose 2) + number of
% alleles -- need to add number of alleles at the end to account for homozygotes

g_card = nchoosek(numAlleles, 2) + numAlleles;
genotypeFactor = struct('var', [genotypeVarChild genotypeVarParentOne genotypeVarParentTwo], 'card', [g_card g_card g_card], 'val', []);

% Each allele has an ID.  Each genotype also has an ID.  We need allele and
% genotype IDs so that we know what genotype and alleles correspond to each
% probability in the .val part of the factor.  For example, the first entry
% in .val corresponds to the probability of having the genotype with
% genotype ID 1, which consists of having two copies of the allele with
% allele ID 1, given that both parents also have the genotype with genotype
% ID 1.  There is a mapping from a pair of allele IDs to genotype IDs and
% from genotype IDs to a pair of allele IDs below; we compute this mapping
% using generateAlleleGenotypeMappers(numAlleles). (A genotype consists of
% 2 alleles.)

[allelesToGenotypes, genotypesToAlleles] = generateAlleleGenotypeMappers(numAlleles);

% One or both of these matrices might be useful.
%
%   1.  allelesToGenotypes: n x n matrix that maps pairs of allele IDs to
%   genotype IDs, where n is the number of alleles -- if
%   allelesToGenotypes(i, j) = k, then the genotype with ID k comprises of
%   the alleles with IDs i and j
%
%   2.  genotypesToAlleles: m x 2 matrix of allele IDs, where m is the
%   number of genotypes -- if genotypesToAlleles(k, :) = [i, j], then the
%   genotype with ID k is comprised of the allele with ID i and the allele
%   with ID j

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INSERT YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fill in genotypeFactor.var.  This should be a 1-D row vector.
% Fill in genotypeFactor.card.  This should be a 1-D row vector.

genotypeFactor.val = zeros(1, prod(genotypeFactor.card));
% Replace the zeros in genotypeFactor.val with the correct values.

for k = 1:prod(genotypeFactor.card)
  assignments = IndexToAssignment(k, genotypeFactor.card);

  child_alleles = genotypesToAlleles(assignments(1), :);
  i = child_alleles(1);
  j = child_alleles(2);
  parent_1_alleles = genotypesToAlleles(assignments(2), :);
  parent_2_alleles = genotypesToAlleles(assignments(3), :);

  genotypeFactor.val(k) = (sum(parent_1_alleles == i) / 2) * (sum(parent_2_alleles == j) / 2) + (sum(parent_1_alleles == j) / 2) * (sum(parent_2_alleles == i) / 2);

  if i == j
    genotypeFactor.val(k) /= 2;
  end
end
% for k = 1:g_card
%   a = genotypesToAlleles(k, 1);
%   b = genotypesToAlleles(k, 2);
%
%   for l = 1:g_card
%
%     c = genotypesToAlleles(l, 1);
%     d = genotypesToAlleles(l, 2);
%
%
%     for m = 1:g_card
%       f = genotypesToAlleles(m, 1);
%       g = genotypesToAlleles(m, 2);
%
%       value = AssignmentToIndex([k l m], genotypeFactor.card);
%
%
%       genotypeFactor = SetValueOfAssignment(genotypeFactor, [k l m], value);
%     end
%   end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
