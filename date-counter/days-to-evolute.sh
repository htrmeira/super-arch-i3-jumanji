#!/bin/bash

current_date=$(date +%j)
end_date=$(date -d "2016-05-28" +%j)
grad_date=$(date -d "2016-06-18" +%j)

days_to_end=$(echo $end_date - $current_date | bc)
days_to_graduation=$(echo $grad_date - $current_date | bc)

echo "$days_to_end/$days_to_graduation"
