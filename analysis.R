counts <- read.csv("yearly_counts.csv")

areal_districts <- c( 1,  2,  3,  4,   5,  6,  7,  8,  9, 10,
                     11, 12,     14,  15, 16, 17, 18, 19, 20,
                         22,     24,  25)
counts <- counts[counts$District %in% areal_districts,]

officer_driven <- c('NARCOTICS',
                    'WEAPONS VIOLATION',
                    'INTERFERENCE WITH PUBLIC OFFICER',
                    'PROSTITUTION',
                    'LIQUOR LAW VIOLATION',
                    'GAMBLING',
                    'CONCEALED CARRY LICENSE VIOLATION',
                    'OBSCENITY',
                    'OTHER NARCOTIC VIOLATION')
counts$officer_driven <- counts$Primary.Type %in% officer_driven

counts$Primary.Type <- as.factor(counts$Primary.Type)
counts$District <- as.factor(counts$District)

m1 <- glm(count ~ poly(Date, 3)*officer_driven + District*officer_driven,
          data=counts,
          family="poisson")

termplot(m1)
