aws-instances() {
    aws ec2 describe-instances  "$@" \
        --no-paginate \
        --query "Reservations[].Instances[] \
            [\
                [Tags[?Key=='Name'].Value][0][0],\
                InstanceId,\
                PublicIpAddress || PrivateIpAddress,\
                ImageId,\
                InstanceType,\
                State.Name,\
                Placement.AvailabilityZone \
            ]" --output table
}
