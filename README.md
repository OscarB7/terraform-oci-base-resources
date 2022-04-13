[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]


# Shared Resources Terraform in OCI

## About The Project

This project uses [Terraform](https://www.terraform.io/intro) to create network resources in [Oracle Cloud Infrastructure](https://www.oracle.com/cloud/free/) (OCI). They can be used by other projects to deploy other resources within the same VCN or subnet.


## Table of Contents

- [About The Project](#about-the-project)
- [Table of Contents](#table-of-contents)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Setup](#setup)
    - [Installation](#installation)
        - [Local Terraform](#local-terraform)
        - [Terraform Cloud](#terraform-cloud)
    - [Destroy Resources](#destroy-resources)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)


## Getting Started

### Prerequisites

You will need the following:

- Install [Terrafrom](https://learn.hashicorp.com/tutorials/terraform/install-cli) or [Docker Engine](https://docs.docker.com/engine/install/) in your machine/desktop/laptop/PC/workstation.
- Understand `<foo>` is a placeholder, and you must delete from `<` to `>` and write the correct value of `foo` when needed, e.g.:
    - if `for=bar`; then `<for>` &rarr; `bar`
    - `"<'region' of the OCI account>"` &rarr; `"us-ashburn-1"`
    - `<DNS IP>` &rarr; `1.1.1.1`


### Setup

Here we will create the `terraform/terraform.tfvars` file and explain how to obtain all the needed values.

*It is important you do not share these parameters and files for recurity reasons.*
&nbsp;  

1. Create an OCI account. Follow this [link](https://signup.cloud.oracle.com/?sourceType=_ref_coc-asset-opcSignIn&language=en_US) to sign up.

2. Create an API KEY in Oracle.

    i. Log in to **OCI** > click on the profile icon (in the upper-right corner) and select your user.
        <kbd>![Select OCI profile](https://i.imgur.com/gI45oCg.jpg)</kbd>
        &nbsp;  

    ii. Go to **API Keys** at the end of the page and create a new one.
        <kbd>![Add keys](https://i.imgur.com/R1Wu89c.jpeg)</kbd>
        &nbsp;  

    iii. Select **Generate API Key Pair** and download the private key.
        <kbd>![Download kwys](https://i.imgur.com/iNIZ7eV.jpeg)</kbd>
        &nbsp;  

    iv. Copy the **Configuration File** for later.
        <kbd>![Copy profile configuration](https://i.imgur.com/1pk4zPM.jpeg)</kbd>
        &nbsp;  

3. Convert the private key downloaded in step 2.iii to a **one-line** base64 string.

    i. If you have a Linux terminal, you may use this approach. Make sure the output is one line; otherwise, remove the new lines manually (leave no spaces) or use the second method.

        ```shell
        base64 <path to the private key file>
        # save this output for later
        ```

    ii. Launch a Docker container to convert the file into a base64 string (run lines one by one):

        ```shell
        docker run --rm -it --name temp ubuntu:latest bash

        # open and run in a new terminal
        docker container cp <path to the private key file> temp:/tmp/private-key.pem
        exit

        # back to the first terminal
        base64 /tmp/private-key.pem -w 0; echo
        # save this output for later
        exit
        ```

4. Clone this project to your machine.

    ```shell
    git clone https://github.com/OscarB7/terraform-oci-base-resources.git
    ```

5. Get your home public IP address.

    Connect to your WiFi at home, go to [this](https://ifconfig.co/ip) page, and copy the IP value.

    This location/network will be allowed to access (1) the Pi-hole DNS service directly without WireGuard connection, (2) the Pi-hole web console, and (3) the OCI instance via SSH.
    &nbsp;  

6. Create the `terraform/terraform.tfvars` file.

    ```shell
    oci_region                   = "<'region' field of the Configuration File in step 2.iv>"
    oci_user_ocid                = "<'user' field of the Configuration File in step 2.iv>"
    oci_tenancy_ocid             = "<'tenancy' field of the Configuration File in step 2.iv>"
    oci_fingerprint              = "<'fingerprint' field of the Configuration File in step 2.iv>"
    oci_private_key_base64       = "<base64 one-line string obained in step 3>"
    your_home_public_ip          = "<public IP address of your home obtained in step 5>"

    # Base/Shared resources (OPTIONAL)
    oci_vcn_id              = "<ID of an already existing VCN in case you want to use it; otherwise, a new one will be created>"
    oci_internet_gateway_id = "<ID of an already existing internet gateway in case you want to use it; otherwise, a new one will be created>"
    oci_route_table_id      = "<ID of an already existing route table in case you want to use it; otherwise, a new one will be created>"
    oci_security_list_id    = "<ID of an already existing security list in case you want to use it; otherwise, a new one will be created>"
    oci_subnet_id           = "<ID of an already existing subnet in case you want to use it; otherwise, a new one will be created>"
    ```

    Parameters:

    - **oci_region**: [*REQUIRED*]  
        Region of your OCI account.  
        `region` parameter from the Configuration File in step 2.iv.
    - **oci_user_ocid**: [*REQUIRED*]  
        User ID of your OCI account.  
        `user` parameter from the Configuration File in step 2.iv.
    - **oci_tenancy_ocid**: [*REQUIRED*]  
        Tenancy ID of your OCI account.  
        `tenancy` parameter from the Configuration File in step 2.iv.
    - **oci_fingerprint**: [*REQUIRED*]  
        The fingerprint of your OCI API Key.  
        `region` parameter from the Configuration File in step 2.iv.
    - **oci_private_key_base64**: [*REQUIRED*]  
        One-line base64 string of the OCI private key downloaded in step 2.iii.  
        This value comes from step 3.
    - **your_home_public_ip**: [*REQUIRED*]  
        Public IP of your home.  
        This value comes from step 6.

    &nbsp;  
    The default values will work fine unless the IP ranges overlap with your existing network.
    &nbsp;  

    Example (**do not use these values**):

    ```shell
    oci_region             = "us-ashburn-1"
    oci_user_ocid          = "ocid1.user.oc1..aaa...wmpxt"
    oci_tenancy_ocid       = "ocid1.tenancy.oc1..aaa...dnkxd"
    oci_fingerprint        = "17:a8:...:01:c4"
    oci_private_key_base64 = "AS0tZS2CR3dJT4BQUkl...ZAS3tLS4="
    your_home_public_ip    = "123.123.123.123/32"
    ```

### Installation

Now that you have completed the [prerequisites](#prerequisites) and [setup](#setup), you can deploy the project to OCI with Terraform.

#### Local Terraform

If you did not install Terraform in your machine, start a Docker container with the Terraform CLI using the following commands:

```shell
docker run --rm -it --name tf --mount type=bind,source="$(pwd)"/terraform,target=/tf --entrypoint sh hashicorp/terraform:1.1.4
# after you are inside the container:
cd /tf
```

Run the following commands one by one from the root folder of this project.

```shell
terraform init
terraform apply
# read the output from terraform and respond 'yes' to confirm you want to create the resources
```

After finishing the deployment, you can read the public IP of the OCI instance from `instance_public_ip` and the Pi-hole DNS and web console ports, `port_pihole_dns` and `port_pihole_web` (we will refer to this information later). Here is an example of the output:

```shell
...
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

availability_domains = "TSJZ:US-ASHBURN-AD-1"
local_oci_internet_gateway_id = "ocid1.internetgateway.oc1.iad.aaa...a"
local_oci_route_table_id = "ocid1.routetable.oc1.iad.aaa...a"
local_oci_security_list_id = "ocid1.securitylist.oc1.iad.aaa...a"
local_oci_subnet_id = "ocid1.subnet.oc1.iad.aaa...a"
local_oci_vcn_id = "ocid1.vcn.oc1.iad.ama...a"
```

Use the output values if needed to use these resources in other projects.

Then exit from the container if it is the case.

```shell
exit
```

You will see new files created in the project directory, which have the current state of the infrastructure. Do not delete those files because you need them for [destroying the resources](#destroy-resources).

#### Terraform Cloud

Here you will use the free tier of [Terraform Cloud](https://cloud.hashicorp.com/products/terraform) as an alternative to the local solution. Why use this instead? Because it will keep track of the Terraform state for you; otherwise, you have to save those files if you want to update or destroy the deployment later. Check the previous link for a full explanation of the benefits.

You can follow this [tutorial](https://learn.hashicorp.com/tutorials/terraform/cloud-sign-up?in=terraform/cloud-get-started), get familiar with it, and repeat the steps for this project.

### Destroy Resources

You can destroy/remove the resources you created with Terraform at any moment. Note you should not edit those resources using the OCI console since it may interfere with this step.

Below is the process if you deployed using [local Terraform](#local-terraform).

If you did not install Terraform in your machine, start a Docker container with the Terraform CLI using the following commands:

```shell
docker run --rm -it --name tf --mount type=bind,source="$(pwd)"/terraform,target=/tf --entrypoint sh hashicorp/terraform:1.1.4
# after you are inside the container:
cd /tf
```

```shell
terraform destroy
# read the output from terraform and respond 'yes' to confirm you want to delete the resources
```

Then exit from the container if it is the case.

```shell
exit
```

If you deployed this project using [Terraform Cloud](#terraform-cloud), the tutorial linked in that section explains how to destroy the resources.



## Contributing

Contributions make the open-source community a great place to learn, inspire, and create. Any improvement you add is greatly appreciated.

Please fork this repo and create a pull request if you have any suggestions. You can also open an issue with the tag `enhancement`.
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## License

Distributed under the MIT License. See `LICENSE.txt` for more information.


## Contact

Oscar Blanco - [Twitter @OsBlancoB](https://twitter.com/OsBlancoB) - [LinkedIn][linkedin-url]

Project Link: [https://github.com/OscarB7/terraform-oci-base-resources](https://github.com/OscarB7/terraform-oci-base-resources)



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/OscarB7/terraform-oci-base-resources.svg?style=for-the-badge
[contributors-url]: https://github.com/OscarB7/terraform-oci-base-resources/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/OscarB7/terraform-oci-base-resources.svg?style=for-the-badge
[forks-url]: https://github.com/OscarB7/terraform-oci-base-resources/network/members
[stars-shield]: https://img.shields.io/github/stars/OscarB7/terraform-oci-base-resources.svg?style=for-the-badge
[stars-url]: https://github.com/OscarB7/terraform-oci-base-resources/stargazers
[issues-shield]: https://img.shields.io/github/issues/OscarB7/terraform-oci-base-resources.svg?style=for-the-badge
[issues-url]: https://github.com/OscarB7/terraform-oci-base-resources/issues
[license-shield]: https://img.shields.io/github/license/OscarB7/terraform-oci-base-resources.svg?style=for-the-badge
[license-url]: https://github.com/OscarB7/terraform-oci-base-resources/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/oscar-blanco-b75842132
